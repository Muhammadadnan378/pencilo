
class AttendanceModel {
  final String classId;
  final String userId;
  final String name;
  final String division;
  final String standard;
  final String? timestamp;

  AttendanceModel({
    required this.classId,
    required this.userId,
    required this.name,
    required this.division,
    required this.standard,
    this.timestamp,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      classId: map['classId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      division: map['division'] ?? '',
      standard: map['standard'] ?? '',
      timestamp: map['createdDateTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'userId': userId,
      'name': name,
      'division': division,
      'standard': standard,
      'createdDateTime': DateTime.now().millisecondsSinceEpoch.toString(),
    };
  }
}
