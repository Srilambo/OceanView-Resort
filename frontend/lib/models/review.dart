class Review {
  final String reviewId;
  final String guestName;
  final String roomType;
  final int rating;
  final String title;
  final String comment;
  final String? stayDate;

  Review({
    required this.reviewId,
    required this.guestName,
    required this.roomType,
    required this.rating,
    required this.title,
    required this.comment,
    this.stayDate,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'] ?? '',
      guestName: json['guestName'] ?? '',
      roomType: json['roomType'] ?? '',
      rating: json['rating'] ?? 0,
      title: json['title'] ?? '',
      comment: json['comment'] ?? '',
      stayDate: json['stayDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'guestName': guestName,
      'roomType': roomType,
      'rating': rating,
      'title': title,
      'comment': comment,
      'stayDate': stayDate,
    };
  }
}
