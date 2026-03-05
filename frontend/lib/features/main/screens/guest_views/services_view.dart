import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/resort_service.dart';
import '../../../../services/api_service.dart';

class ServicesView extends StatefulWidget {
  const ServicesView({Key? key}) : super(key: key);

  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView>
    with SingleTickerProviderStateMixin {
  late Future<List<ResortService>> _futureServices;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _futureServices = ApiService.getAllServices();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
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
                const SizedBox(height: 8),
                Text(
                  'Please check back later for available resort services.',
                  style: GoogleFonts.montserrat(color: Colors.grey.shade500),
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
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = services[index];
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            (index / services.length) * 0.5,
                            1.0,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      ),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0, end: 1).animate(
                          CurvedAnimation(
                            parent: _animationController,
                            curve: Interval(
                              (index / services.length) * 0.5,
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          ),
                        ),
                        child: _buildServiceCard(service),
                      ),
                    );
                  },
                  childCount: services.length,
                ),
              ),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image Area
          Container(
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
              ),
            ),
            child: Center(
              child: Icon(
                getIcon(service.icon),
                size: 60,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          service.category,
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      if (!service.available)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'UNAVAILABLE',
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    service.serviceName,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0D47A1),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      service.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            service.duration,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        service.price > 0
                            ? '\$${service.price.toStringAsFixed(2)}'
                            : 'Free',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF57C00),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
