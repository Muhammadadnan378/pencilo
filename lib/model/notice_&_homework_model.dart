class NoticeHomeWorkModel {
  final String teacherUid;
  final String noticeId;
  final String title;
  final String teacherName;
  final String note;
  final String standard;
  final String division;
  final List<String> noticeIsWatched;
  final List<String>? isHomeWorkDon;
  final String? imageUrl;
  final DateTime createdAt;

  NoticeHomeWorkModel({
    required this.teacherUid,
    required this.noticeId,
    required this.title,
    required this.teacherName,
    required this.note,
    required this.standard,
    required this.division,
    required this.noticeIsWatched,
    this.isHomeWorkDon,
    this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toNotice() {
    return {
      'teacherUid': teacherUid,
      'noticeId': noticeId,
      'title': title,
      'teacherName': teacherName,
      'note': note,
      'standard': standard,
      'division': division,
      'isHomeWorkDon': isHomeWorkDon,
      'imageUrl': imageUrl ?? '',
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toHomeWork() {
    return {
      'teacherUid': teacherUid,
      'noticeId': noticeId,
      'title': title,
      'teacherName': teacherName,
      'note': note,
      'standard': standard,
      'division': division,
      'noticeIsWatched': noticeIsWatched,
      'isHomeWorkDon': isHomeWorkDon,
      'imageUrl': imageUrl ?? '',
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoticeHomeWorkModel.fromMap(Map<String, dynamic> map) {
    return NoticeHomeWorkModel(
      teacherUid: map['teacherUid'],
      noticeId: map['noticeId'],
      title: map['title'],
      teacherName: map['teacherName'],
      note: map['note'],
      standard: map['standard'],
      division: map['division'],
      noticeIsWatched: List<String>.from(map['noticeIsWatched'] ?? []),
      isHomeWorkDon: List<String>.from(map['isHomeWorkDon'] ?? []),
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

}
