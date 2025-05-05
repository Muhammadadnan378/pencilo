import 'package:intl/intl.dart';

class EventModel {
  String userId;
  String eventId;
  String time;
  String selectedEventType;
  String selectedCity;
  String selectedState;
  String name;
  String schoolName;
  String entryFee;
  String winnerAmount;
  String contactNumber;
  String rules;
  String selectedDateTime;
  List<Map<String, dynamic>> participants = [];  // Changed from List<String> to List<Map<String, dynamic>>

  // Constructor for initializing the EventModel
  EventModel({
    required this.time,
    required this.selectedEventType,
    required this.selectedCity,
    required this.selectedState,
    required this.name,
    required this.schoolName,
    required this.entryFee,
    required this.winnerAmount,
    required this.contactNumber,
    required this.rules,
    required this.selectedDateTime,
    required this.userId,
    required this.eventId,
    required this.participants,  // Now expects a list of maps
  });

  // Method to convert EventModel object to a map (to be used in storage, API calls, etc.)
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'selectedEventType': selectedEventType,
      'selectedCity': selectedCity,
      'selectedState': selectedState,
      'name': name,
      'schoolName': schoolName,
      'entryFee': entryFee,
      'winnerAmount': winnerAmount,
      'contactNumber': contactNumber,
      'rules': rules,
      'selectedDateTime': selectedDateTime,
      'userId': userId,
      'eventId': eventId,
      'participants': participants,  // Store as a list of maps
    };
  }

  // Method to create an EventModel instance from a map
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      userId: map['userId'] ?? '',
      eventId: map['eventId'] ?? '',
      time: map['time'] ?? '',
      selectedEventType: map['selectedEventType'] ?? '',
      selectedCity: map['selectedCity'] ?? '',
      selectedState: map['selectedState'] ?? '',
      name: map['name'] ?? '',
      schoolName: map['schoolName'] ?? '',
      entryFee: map['entryFee'] ?? '',
      winnerAmount: map['winnerAmount'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      rules: map['rules'] ?? '',
      selectedDateTime: map['selectedDateTime'] ?? '',
      participants: List<Map<String, dynamic>>.from(map['participants'] ?? []),  // Handle participants as a list of maps
    );
  }
}
