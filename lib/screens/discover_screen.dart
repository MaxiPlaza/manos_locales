import 'package:flutter/material.dart';
import '../services/service_service.dart';
import '../services/category_service.dart';
import '../models/service_model.dart';
import '../models/category_model.dart';
import '../widgets/service_card_discover.dart';
import '../widgets/filter_bottom_sheet.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _serviceService = ServiceService();
  final _categoryService = CategoryService();

  List<ServiceModel> _services = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  // Filtros
  String? _selectedZone;
  List<String> _selectedJobTypes = [];

  // Zonas disponibles
  final List<String> _zones = [
    'Zona Norte',
    'Zona Sur',
    'Zona Este',
    'Zona Oeste',
  ];

  // Tipos de empleo (basados en categorías)
  final List<String> _jobTypes = [
    'Servicios de Hogar',
    'Tecnología',
    'Automación',
    'Educación y Clases',
    'Todos',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final categories = await _categoryService.getAllCategories();
      final services = await _serviceService.getAllServices(limit: 50);

      setState(() {
        _categories = categories;
        _services = _filterServices(services);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<ServiceModel> _filterServices(List<ServiceModel> services) {
    List<ServiceModel> filtered = services;

    // Filtrar por zona
    if (_selectedZone != null && _selectedZone!.isNotEmpty) {
      filtered = filtered.where((service) {
        return service.locationText
            .toLowerCase()
            .contains(_getZoneKeyword(_selectedZone!));
      }).toList();
    }

    // Filtrar por tipo de empleo (categorías)
    if (_selectedJobTypes.isNotEmpty && !_selectedJobTypes.contains('Todos')) {
      filtered = filtered.where((service) {
        return _matchesJobType(service.category);
      }).toList();
    }

    return filtered;
  }

  String _getZoneKeyword(String zone) {
    switch (zone) {
      case 'Zona Norte':
        return 'norte|belgrano|nuñez|palermo|colegiales|urquiza';
      case 'Zona Sur':
        return 'sur|boca|barracas|pompeya|parque';
      case 'Zona Este':
        return 'este|puerto madero|retiro|recoleta';
      case 'Zona Oeste':
        return 'oeste|caballito|flores|devoto|paternal';
      default:
        return '';
    }
  }

  bool _matchesJobType(String category) {
    for (var jobType in _selectedJobTypes) {
      switch (jobType) {
        case 'Servicios de Hogar':
          if ([
            'limpieza',
            'plomeria',
            'electricidad',
            'gasista',
            'pintura',
            'carpinteria'
          ].contains(category)) {
            return true;
          }
          break;
        case 'Tecnología':
          if (category == 'reparacion_pc') return true;
          break;
        case 'Automación':
          if (category == 'electricidad') return true;
          break;
        case 'Educación y Clases':
          if (category == 'clases_particulares') return true;
          break;
      }
    }
    return false;
  }

  void _showLocationFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        title: 'Localización',
        icon: Icons.location_on,
        options: _zones,
        selectedOption: _selectedZone,
        onSelected: (value) {
          setState(() {
            _selectedZone = value;
            _loadData();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showJobTypeFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF001F3F),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.work, color: Colors.blue[300]),
                const SizedBox(width: 12),
                const Text(
                  'Tipo de empleo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._jobTypes.map((jobType) {
              final isSelected = _selectedJobTypes.contains(jobType);
              return CheckboxListTile(
                title: Text(
                  jobType,
                  style: const TextStyle(color: Colors.white),
                ),
                value: isSelected,
                activeColor: Colors.blue,
                checkColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    if (jobType == 'Todos') {
                      if (value == true) {
                        _selectedJobTypes = ['Todos'];
                      } else {
                        _selectedJobTypes.clear();
                      }
                    } else {
                      if (value == true) {
                        _selectedJobTypes.remove('Todos');
                        _selectedJobTypes.add(jobType);
                      } else {
                        _selectedJobTypes.remove(jobType);
                      }
                    }
                  });
                },
              );
            }).toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _loadData();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Aplicar Filtros'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001F3F), // Azul oscuro
              Color(0xFF000B1F), // Azul más oscuro
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descubrir',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTab('Puestos de trabajo', isSelected: true),
                        const SizedBox(width: 12),
                        _buildTab('Candidatos', isSelected: false),
                      ],
                    ),
                  ],
                ),
              ),

              // Filtros
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildFilterButton(
                        icon: Icons.location_on,
                        label: _selectedZone ?? 'Zona (Toca para elegir)',
                        onTap: _showLocationFilter,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterButton(
                        icon: Icons.work,
                        label: _selectedJobTypes.isEmpty
                            ? 'Todos'
                            : _selectedJobTypes.length == 1
                                ? _selectedJobTypes.first
                                : '${_selectedJobTypes.length} seleccionados',
                        onTap: _showJobTypeFilter,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Lista de servicios (Manos locales)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Manos locales',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Grid de servicios
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : _services.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No hay servicios disponibles',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                      :ListView.builder(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  itemCount: _services.length,
  itemBuilder: (context, index) {
    return ServiceCardDiscover(
      service: _services[index],
      onTap: () {
        Navigator.pushNamed(context, '/detalle_candidato');
      },
    );
  },
)

              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildTab(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[700]!,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[400],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF001F3F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue[300], size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF001F3F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Inicio', isSelected: true),
              _buildNavItem(Icons.chat_bubble_outline, 'Mensajes',
                  isSelected: false),
              _buildNavItem(Icons.description_outlined, 'Documentos',
                  isSelected: false),
              _buildNavItem(Icons.person_outline, 'Perfil', isSelected: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label,
      {required bool isSelected}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? Colors.blue : Colors.grey[600],
          size: 28,
        ),
        const SizedBox(height: 4),
        if (isSelected)
          Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
