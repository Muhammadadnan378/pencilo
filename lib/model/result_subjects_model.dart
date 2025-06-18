class ResultModel {
  final String standard;
  final String division;
  final String? resultInfoId;
  final String? schoolName;
  final List<String>? subjectNameList;
  final List<String>? totalMarksList;
  final List<String>? practicalMarksList;
  final String? studentUid;
  final String? studentName;
  final String? resultSubjectId;
  final String? subjectName;
  final String? subjectTotalMarks;
  final String? subjectPracticalMarks;
  final String? term;
  final String? rollNo;
  final String? totalMarks;

  ResultModel({
    required this.standard,
    required this.division,
    this.resultInfoId,
    this.schoolName,
    this.subjectNameList,
    this.totalMarksList,
    this.practicalMarksList,
    this.studentUid,
    this.studentName,
    this.resultSubjectId,
    this.subjectName,
    this.subjectTotalMarks,
    this.subjectPracticalMarks,
    this.term,
    this.rollNo,
    this.totalMarks,
  });

  Map<String, dynamic> resultInfoToMap() {
    return {
      'standard': standard,
      'division': division,
      'resultInfoId': resultInfoId,
      'schoolName': schoolName,
      'subjectNameList': subjectNameList,
      'totalMarks': totalMarksList,
      'practicalMarks': practicalMarksList,
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
      'subjectTotalMarks': subjectTotalMarks,
      'subjectPracticalMarks': subjectPracticalMarks,
      'term': term,
      'rollNo': rollNo,
      'totalMarks': totalMarks,
    };
  }



  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      standard: map['standard'] ?? '',
      division: map['division'] ?? '',
      resultInfoId: map['resultInfoId'] ?? '',
      schoolName: map['schoolName'] ?? '',
      subjectNameList: List<String>.from(map['subjectNameList'] ?? []),
      totalMarksList: List<String>.from(map['totalMarksList'] ?? []),
      practicalMarksList: List<String>.from(map['practicalMarksList'] ?? []),
      studentUid: map['studentUid'] ?? '',
      resultSubjectId: map['resultSubjectId'] ?? '',
      studentName: map['studentName'] ?? '',
      subjectName: map['subjectName'] ?? '',
      subjectTotalMarks: map['subjectTotalMarks'] ?? '',
      subjectPracticalMarks: map['subjectPracticalMarks'] ?? '',
      term: map['term'] ?? '',
      rollNo: map['rollNo'] ?? '',
      totalMarks: map['totalMarks'] ?? '',
    );
  }
}
