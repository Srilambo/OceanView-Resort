import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../models/resort_service.dart';
import '../../../../models/reservation.dart';
import '../../../../services/api_service.dart';
import '../../../authentication/providers/auth_provider.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({Key? key}) : super(key: key);

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView>
    with SingleTickerProviderStateMixin {
  late Future<List<ResortService>> _futureServices;
  late AnimationController _animationController;

  Reservation? _activeReservation;
  String? _guestId;
  bool _loadingReservation = true;
  final Set<String> _addedServices = {};
  final Map<String, bool> _loadingAdd = {};

  @override
  void initState() {
    super.initState();
    _futureServices = ApiService.getAllServices();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _initData();
  }

  Future<void> _initData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null) {
        // First get the guest ID from the user ID
        final guest = await ApiService.getGuestByUserId(user.id);
        _guestId = guest.guestId;

        // Then load reservations
        await _loadActiveReservation();
      } else {
        setState(() => _loadingReservation = false);
      }
    } catch (e) {
      debugPrint('Error initializing services view: $e');
      // Fallback to demo ID if needed for testing, or just show error
      // _guestId = 'guest-sri-001';
      // await _loadActiveReservation();
      if (mounted) setState(() => _loadingReservation = false);
    }
  }

  Future<void> _loadActiveReservation() async {
    if (_guestId == null) return;
    try {
      final reservations = await ApiService.getGuestReservations(_guestId!);
      // Priority: CHECKED_IN > CONFIRMED > PENDING
      final active = reservations
          .where((r) =>
              r.status == 'CHECKED_IN' ||
              r.status == 'CONFIRMED' ||
              r.status == 'PENDING')
          .toList();

      // Sort to prefer CHECKED_IN
      active.sort((a, b) {
        if (a.status == 'CHECKED_IN') return -1;
        if (b.status == 'CHECKED_IN') return 1;
        return 0;
      });

      if (mounted) {
        setState(() {
          _activeReservation = active.isNotEmpty ? active.first : null;
          _loadingReservation = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingReservation = false);
    }
  }

  Future<void> _addServiceToBill(ResortService service) async {
    if (_activeReservation == null) return;
    setState(() => _loadingAdd[service.serviceId] = true);
    try {
      await ApiService.addServiceToReservation(
        reservationId: _activeReservation!.reservationId,
        serviceId: service.serviceId,
        serviceName: service.serviceName,
        servicePrice: service.price,
      );
      setState(() => _addedServices.add(service.serviceId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${service.serviceName} added to your bill!',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                ),
              ),
            ]),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingAdd[service.serviceId] = false);
    }
  }

  void _showServiceDetails(ResortService service) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Image.asset(
                    _getServiceImage(service.category),
                    height: 240,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            service.category.toUpperCase(),
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1565C0),
                            ),
                          ),
                        ),
                        Text(
                          service.price > 0
                              ? '\$${service.price.toStringAsFixed(2)}'
                              : 'Free',
                          style: GoogleFonts.montserrat(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF57C00),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      service.serviceName,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Text(
                          'Duration: ${service.duration}',
                          style: GoogleFonts.montserrat(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Overview',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (_activeReservation != null &&
                        service.available &&
                        service.price > 0 &&
                        !_addedServices.contains(service.serviceId))
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _addServiceToBill(service);
                          },
                          icon: const Icon(Icons.add_shopping_cart_rounded),
                          label: Text(
                            'Add to Bill & Book Now',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      )
                    else if (_addedServices.contains(service.serviceId))
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Already added to your bill',
                              style: GoogleFonts.montserrat(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getServiceImage(String category) {
    switch (category.toUpperCase()) {
      case 'WELLNESS':
      case 'SPA':
        return 'assets/images/luxury_pool.png';
      case 'ADVENTURE':
        return 'assets/images/hero_beach_landing.png';
      case 'DINING':
        return 'assets/images/room1_ocean_suite_img2.png';
      default:
        return 'assets/images/resort_hero.png';
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ResortService>>(
      future: _futureServices,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading services: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final services = snapshot.data ?? [];

        if (services.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.spa, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No Services Available',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        _animationController.forward();

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resort Services',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover experiences tailored for your relaxation',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (!_loadingReservation && _activeReservation != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.hotel_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _activeReservation!.status == 'CHECKED_IN'
                                    ? 'You are checked in (Room ${_activeReservation!.roomNumber}). Add services to your bill below.'
                                    : 'You have an upcoming stay (Room ${_activeReservation!.roomNumber}). Pre-book services below.',
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900
                      ? 3
                      : MediaQuery.of(context).size.width > 600
                          ? 2
                          : 1,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: _activeReservation != null ? 0.75 : 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = services[index];
                    return FadeTransition(
                      opacity: _animationController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Interval((index / services.length) * 0.4, 1.0,
                              curve: Curves.easeOut),
                        )),
                        child: _buildServiceCard(service),
                      ),
                    );
                  },
                  childCount: services.length,
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
          ],
        );
      },
    );
  }

  Widget _buildServiceCard(ResortService service) {
    IconData getIcon(String iconString) {
      switch (iconString) {
        case 'spa':
          return Icons.spa;
        case 'fitness_center':
          return Icons.fitness_center;
        case 'scuba_diving':
          return Icons.scuba_diving;
        case 'restaurant':
          return Icons.restaurant;
        case 'pool':
          return Icons.pool;
        case 'dinner_dining':
          return Icons.dinner_dining;
        case 'sailing':
          return Icons.sailing;
        case 'child_care':
          return Icons.child_care;
        default:
          return Icons.star;
      }
    }

    final isAdded = _addedServices.contains(service.serviceId);
    final isLoading = _loadingAdd[service.serviceId] == true;
    final hasActiveStay = _activeReservation != null;

    return InkWell(
      onTap: () => _showServiceDetails(service),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  _getServiceImage(service.category),
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(getIcon(service.icon),
                            size: 14, color: const Color(0xFF1565C0)),
                        const SizedBox(width: 4),
                        Text(
                          service.category,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceName,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0D47A1),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        service.description,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service.duration,
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          service.price > 0
                              ? '\$${service.price.toStringAsFixed(2)}'
                              : 'Free',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF57C00),
                          ),
                        ),
                      ],
                    ),
                    if (hasActiveStay &&
                        service.available &&
                        service.price > 0) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: isAdded
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check,
                                        size: 14, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text('Added',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green)),
                                  ],
                                ),
                              )
                            : ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _addServiceToBill(service),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1565C0),
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 14,
                                        width: 14,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white))
                                    : Text('Add to Bill',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
