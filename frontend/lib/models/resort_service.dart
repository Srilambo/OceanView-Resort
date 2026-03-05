class ResortService {
  final String serviceId;
  final String serviceName;
  final String category;
  final String description;
  final double price;
  final String duration;
  final bool available;
  final String icon;

  ResortService({
    required this.serviceId,
    required this.serviceName,
    required this.category,
    required this.description,
    required this.price,
    required this.duration,
    required this.available,
    required this.icon,
  });

  factory ResortService.fromJson(Map<String, dynamic> json) {
    return ResortService(
      serviceId: json['serviceId'] ?? '',
      serviceName: json['serviceName'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      duration: json['duration'] ?? '',
      available: json['available'] ?? true,
      icon: json['icon'] ?? '',
    );
  }
}
