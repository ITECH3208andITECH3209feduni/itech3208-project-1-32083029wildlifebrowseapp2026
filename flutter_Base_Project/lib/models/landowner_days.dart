class LandownerDays {
  LandownerDays({
    required this.days,
  });

  final String days;

  factory LandownerDays.fromJson(Map<String, dynamic> landownerJson) {
    
    final day = landownerJson['days'] as String; 

    return LandownerDays(
      days: day,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
    };
  }
}