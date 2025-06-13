
class AttendanceModel {
  final String? studentUid;
  final String? studentName;
  final String? division;
  final String? standard;
  final String? dateTime;
  final String? startDateTime;
  final String? rollNo;
  final String? schoolName;
  final bool? isPresent;

  AttendanceModel({
    this.studentUid,
    this.studentName,
    this.division,
    this.standard,
    this.dateTime,
    this.startDateTime,
    this.rollNo,
    this.schoolName,
    this.isPresent,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      studentUid: map['studentUid'] ?? '',
      studentName: map['studentName'] ?? '',
      division: map['division'] ?? '',
      standard: map['standard'] ?? '',
      dateTime: map['dateTime'] ?? '',
      startDateTime: map['startDateTime'] ?? '',
      rollNo: map['rollNo'] ?? '',
      schoolName: map['schoolName'] ?? '',
      isPresent: map['isPresent'] ?? false,
    );
  }

  Map<String, dynamic> addStudent() {
    return {
      'studentUid': studentUid,
      'studentName': studentName,
      'division': division,
      'standard': standard,
      'rollNo': rollNo,
      'schoolName': schoolName,
      'dateTime': dateTime,
    };
  }

  Map<String, dynamic> submitAttendance() {
    return {
      'studentUid': studentUid,
      'rollNo': rollNo,
      'dateTime': dateTime,
      'isPresent': isPresent,
      'division': division,
      'standard': standard,
    };
  }

  Map<String, dynamic> updateAttendance() {
    return {
      'studentName': studentName,
      'standard': standard,
      'division': division,
      'schoolName': schoolName,
    };
  }


}
