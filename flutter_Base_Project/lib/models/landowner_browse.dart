class LandownerBrowse {
  LandownerBrowse({
    required this.browse_Name,
  });

  final String browse_Name;

  // factory LandownerBrowse.fromJson(Map<String, dynamic> landownerJson) {
  //   final browse_Name = landownerJson['browse_Name'] as String; 

  //   return LandownerBrowse(
  //     browse_Name: browse_Name,
  //   );
  // }
  
  String getBrowseName() {
    return browse_Name;
  }

  Map<String, dynamic> toJson() {
    return {
      'browse_Name': browse_Name,
    };
  }
}