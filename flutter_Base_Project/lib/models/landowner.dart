import 'landowner_browse.dart';
import 'landowner_days.dart';
import 'landowner_times.dart';

class Landowner {
  Landowner({
    required this.userID,
    required this.state,
    required this.timestamp,
    required this.browse,
    required this.address,
    this.accessDetails,
    required this.phone,
    required this.days,
    required this.times,
    required this.warningRequired,
    this.extraDetails,
  });

  // ? Allows null
  // final means it can't be changed later
  final String userID;
  String state;
  final String timestamp;
  List<LandownerBrowse> browse;
  String address;
  String? accessDetails;
  String phone;
  List<LandownerDays> days;
  List<LandownerTimes> times;
  bool warningRequired;
  String? extraDetails;

  // Helper methods
  // Gets browse names as a list
  List<String> getBrowseNames() {
    return browse.map((a) => a.browse_Name).toList();
  }

  // Gets days as a list
  List<String> getDays() {
    return days.map((a) => a.days).toList();
  }

  // Gets times as a list
  List<String> getTimes() {
    return times.map((a) => a.times).toList();
  }

  set updateState(String newState) {
    state = newState;
  }

  factory Landowner.fromJson(Map<String, dynamic> requestJson) {

    final userID = requestJson['userID'] as String;
    final state = requestJson['state'] as String;
    final timestamp = requestJson['timestamp'] as String;
    final browseData = requestJson['browse'] as List<dynamic>;
    final address = requestJson['address'] as String;
    final accessDetails = requestJson['accessDetails'] as String?;
    final phone = requestJson['phone'] as String;
    final daysData = requestJson['days'] as List<dynamic>;
    final timesData = requestJson['times'] as List<dynamic>;
    final warningRequired = requestJson['warningRequired'] as bool;
    final extraDetails = requestJson['extraDetails'] as String?;

    return Landowner(
      userID: userID,
      state: state,
      timestamp: timestamp,
      browse: browseData
      .map((data) =>
        LandownerBrowse.fromJson(data as Map<String, dynamic>))
      .toList(),
      address: address,
      accessDetails: accessDetails,
      phone: phone,
      days: daysData
      .map((data) =>
        LandownerDays.fromJson(data as Map<String, dynamic>))
      .toList(),
      times: timesData
      .map((data) =>
        LandownerTimes.fromJson(data as Map<String, dynamic>))
      .toList(),
      warningRequired: warningRequired,
      extraDetails: extraDetails,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'state': state,
      'timestamp': timestamp,
      'browseData': browse,
      'address': address,
      'accessDetails': accessDetails,
      'phone': phone,
      'daysData': days,
      'timesData': times,
      'warningRequired': warningRequired,
      'extraDetails': extraDetails,
    };
  }
}