class Review {
  final double rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Review({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      date: json['date'],
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    'date': date,
    'reviewerName': reviewerName,
    'reviewerEmail': reviewerEmail,
  };
}