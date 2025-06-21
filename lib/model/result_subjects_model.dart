class ResultModel {
  final String standard;
  final String division;
  final String? resultInfoId;
  final String? schoolName;
  final List<String>? subjectNameList;
  final List<String>? theoryMarksList;
  final List<String>? practicalMarksList;
  final String? studentUid;
  final String? studentName;
  final String? resultSubjectId;
  final String? subjectName;
  final String? subjectTheoryMarks;
  final String? subjectPracticalMarks;
  final String? term;
  final String? rollNo;
  final int? totalSubjectMarks;

  ResultModel({
    required this.standard,
    required this.division,
    this.resultInfoId,
    this.schoolName,
    this.subjectNameList,
    this.theoryMarksList,
    this.practicalMarksList,
    this.studentUid,
    this.studentName,
    this.resultSubjectId,
    this.subjectName,
    this.subjectTheoryMarks,
    this.subjectPracticalMarks,
    this.term,
    this.rollNo,
    this.totalSubjectMarks,
  });

  Map<String, dynamic> resultInfoToMap() {
    return {
      'standard': standard,
      'division': division,
      'resultInfoId': resultInfoId,
      'schoolName': schoolName,
      'subjectNameList': subjectNameList,
      'theoryMarksList': theoryMarksList,
      'practicalMarksList': practicalMarksList,
    };
  }

  Map<String, dynamic> resultSubjectToMap() {
    return {
      'resultSubjectId': resultSubjectId,
      'division': division,
      'standard': standard,
      'schoolName': schoolName,
      'studentName': studentName,
      'subjectName': subjectName,
      'studentUid': studentUid,
      'subjectTheoryMarks': subjectTheoryMarks,
      'subjectPracticalMarks': subjectPracticalMarks,
      'term': term,
      'rollNo': rollNo,
      'totalSubjectMarks': totalSubjectMarks,
    };
  }



  factory ResultModel.fromMap(Map<dynamic, dynamic> map) {
    return ResultModel(
      standard: map['standard'] ?? '',
      division: map['division'] ?? '',
      resultInfoId: map['resultInfoId'] ?? '',
      schoolName: map['schoolName'] ?? '',
      subjectNameList: List<String>.from(map['subjectNameList'] ?? []),
      theoryMarksList: List<String>.from(map['theoryMarksList'] ?? []),
      practicalMarksList: List<String>.from(map['practicalMarksList'] ?? []),
      studentUid: map['studentUid'] ?? '',
      resultSubjectId: map['resultSubjectId'] ?? '',
      studentName: map['studentName'] ?? '',
      subjectName: map['subjectName'] ?? '',
      subjectTheoryMarks: map['subjectTheoryMarks'] ?? '',
      subjectPracticalMarks: map['subjectPracticalMarks'] ?? '',
      term: map['term'] ?? '',
      rollNo: map['rollNo'] ?? '',
      totalSubjectMarks: map['totalSubjectMarks'] ?? 0,
    );
  }
}
