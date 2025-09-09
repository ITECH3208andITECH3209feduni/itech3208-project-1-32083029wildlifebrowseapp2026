class LandownerTimes {
  LandownerTimes({
    required this.times,
  });

  final String times;

  // factory LandownerTimes.fromJson(Map<String, dynamic> landownerJson) {
  //   final time = landownerJson['times'] as String; 

  //   return LandownerTimes(
  //     times: time,
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'times': times,
    };
  }
}