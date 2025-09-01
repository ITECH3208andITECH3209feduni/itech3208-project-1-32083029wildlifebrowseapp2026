class LandownerTimes {
  LandownerTimes({
    required this.times,
  });

  final String times;

  factory LandownerTimes.fromJson(Map<String, dynamic> landownerJson) {
    
    final times = landownerJson['times'] as String; 

    return LandownerTimes(
      times: times,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'times': times,
    };
  }
}