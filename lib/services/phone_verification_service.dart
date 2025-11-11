import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneVerificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ⚠️ IMPORTANTE: Configurar estas credenciales de Twilio
  static const String TWILIO_ACCOUNT_SID = 'TU_ACCOUNT_SID'; // Cambiar
  static const String TWILIO_AUTH_TOKEN = 'TU_AUTH_TOKEN'; // Cambiar
  static const String TWILIO_PHONE_NUMBER = '+1234567890'; // Tu número Twilio

  // ============== ENVIAR CÓDIGO DE VERIFICACIÓN ==============
  Future<void> sendVerificationCode({
    required String userId,
    required String phone,
  }) async {
    try {
      // 1. Generar código de 6 dígitos
      final code = _generateCode();

      // 2. Calcular expiración (10 minutos)
      final expiry = DateTime.now().add(Duration(minutes: 10));

      // 3. Guardar código en Firestore
      await _firestore.collection('users').doc(userId).update({
        'verificationCode': code,
        'verificationCodeExpiry': Timestamp.fromDate(expiry),
      });

      // 4. Enviar SMS
      await _sendSMS(phone, code);

      print('✅ Código enviado a $phone: $code'); // Solo para debug
    } catch (e) {
      throw 'Error al enviar código de verificación: $e';
    }
  }

  // ============== VERIFICAR CÓDIGO ==============
  Future<bool> verifyCode({
    required String userId,
    required String code,
  }) async {
    try {
      // 1. Obtener usuario
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw 'Usuario no encontrado';
      }

      final data = userDoc.data()!;
      final savedCode = data['verificationCode'] ?? '';
      final expiryTimestamp = data['verificationCodeExpiry'] as Timestamp?;

      // 2. Validar que existe código y expiración
      if (savedCode.isEmpty || expiryTimestamp == null) {
        throw 'No hay código de verificación pendiente';
      }

      final expiry = expiryTimestamp.toDate();

      // 3. Verificar si expiró
      if (DateTime.now().isAfter(expiry)) {
        throw 'El código ha expirado. Solicita uno nuevo';
      }

      // 4. Verificar si el código coincide
      if (savedCode != code) {
        return false;
      }

      // 5. ✅ CÓDIGO CORRECTO: Marcar teléfono como verificado
      await _firestore.collection('users').doc(userId).update({
        'phoneVerified': true,
        'verificationCode': '', // Limpiar código
        'verificationCodeExpiry': null, // Limpiar expiración
      });

      return true;
    } catch (e) {
      throw 'Error al verificar código: $e';
    }
  }

  // ============== REENVIAR CÓDIGO ==============
  Future<void> resendCode({
    required String userId,
    required String phone,
  }) async {
    try {
      // Verificar que no se esté enviando demasiado rápido (rate limiting)
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data();

      if (data != null && data['verificationCodeExpiry'] != null) {
        final expiry = (data['verificationCodeExpiry'] as Timestamp).toDate();
        final timeSinceLastCode = DateTime.now().difference(
          expiry.subtract(Duration(minutes: 10)),
        );

        // Si han pasado menos de 1 minuto, no permitir reenvío
        if (timeSinceLastCode.inSeconds < 60) {
          throw 'Debes esperar 1 minuto antes de solicitar otro código';
        }
      }

      // Enviar nuevo código
      await sendVerificationCode(userId: userId, phone: phone);
    } catch (e) {
      throw 'Error al reenviar código: $e';
    }
  }

  // ============== GENERAR CÓDIGO ALEATORIO DE 6 DÍGITOS ==============
  String _generateCode() {
    final random = Random();
    final code = 100000 + random.nextInt(900000);
    return code.toString();
  }

  // ============== ENVIAR SMS CON TWILIO ==============
  Future<void> _sendSMS(String phoneNumber, String code) async {
    try {
      // OPCIÓN 1: TWILIO (PRODUCCIÓN)
      await _sendViaTwilio(phoneNumber, code);

      // OPCIÓN 2: Para testing/desarrollo (comentar en producción)
      // print('📱 SMS a $phoneNumber: Tu código de Manos Locales es: $code');
    } catch (e) {
      // Si falla Twilio, al menos loguear
      print('❌ Error al enviar SMS: $e');
      print('📱 Código para $phoneNumber: $code'); // Fallback para debug
      rethrow;
    }
  }

  // ============== ENVIAR VÍA TWILIO ==============
  Future<void> _sendViaTwilio(String phoneNumber, String code) async {
    final url = Uri.parse(
      'https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/Messages.json',
    );

    final message =
        'Tu código de verificación de Manos Locales es: $code. Válido por 10 minutos.';

    final credentials = base64Encode(
      utf8.encode('$TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN'),
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'From': TWILIO_PHONE_NUMBER, 'To': phoneNumber, 'Body': message},
    );

    if (response.statusCode != 201) {
      throw 'Error de Twilio: ${response.body}';
    }

    print('✅ SMS enviado exitosamente vía Twilio');
  }

  // ============== VERIFICAR SI USUARIO ESTÁ VERIFICADO ==============
  Future<bool> isPhoneVerified(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      return userDoc.data()?['phoneVerified'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // ============== OBTENER TIEMPO RESTANTE PARA REENVIAR ==============
  Future<int> getSecondsUntilCanResend(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data();

      if (data == null || data['verificationCodeExpiry'] == null) {
        return 0; // Puede enviar inmediatamente
      }

      final expiry = (data['verificationCodeExpiry'] as Timestamp).toDate();
      final sentAt = expiry.subtract(Duration(minutes: 10));
      final elapsed = DateTime.now().difference(sentAt);

      final waitTime = 60 - elapsed.inSeconds;
      return waitTime > 0 ? waitTime : 0;
    } catch (e) {
      return 0;
    }
  }
}
