class SubjectModel {
  String? uid;
  String? subjectId;
  String? subjectName;
  String? subjectParts;
  String? ans;
  String? chapterName;
  String? chapterPart;
  String? question;
  String? chapterId;
  String? youtubeVideoPath;
  String? imgUrl;
  List<Map<String, dynamic>>? questions; // List to hold multiple questions


  SubjectModel({
    this.uid,
    this.subjectId,
    this.subjectName,
    this.subjectParts,
    this.ans,
    this.chapterName,
    this.chapterPart,
    this.question,
    this.chapterId,
    this.youtubeVideoPath,
    this.imgUrl,
    this.questions,
  });

  /// Map for only subject-related fields
  Map<String, dynamic> toSubjectMap() {
    return {
      'uid': uid,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'subjectParts': subjectParts,
    };
  }

  /// Map for only chapter-related fields
  Map<String, dynamic> toChapterMap() {
    return {
      'ans': ans,
      'subjectId': subjectId,
      'chapterName': chapterName,
      'chapterPart': chapterPart,
      'question': question,
      'chapterId': chapterId,
      'youtubeVideoPath': youtubeVideoPath,
      'imgUrl': imgUrl,
    };
  }

  factory SubjectModel.fromSubject(Map<String, dynamic> json) {
    return SubjectModel(
      uid: json['uid'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      subjectParts: json['subjectParts'],
    );
  }

  factory SubjectModel.fromMap(Map<String, dynamic> json) {
    return SubjectModel(
      uid: json['uid'],
      subjectId: json['subjectId'],
      subjectName: json['subjectName'],
      subjectParts: json['subjectParts'],
      ans: json['ans'],
      chapterName: json['chapterName'],
      chapterPart: json['chapterPart'],
      question: json['question'],
      chapterId: json['chapterId'],
      youtubeVideoPath: json['youtubeVideoPath'],
      imgUrl: json['imgUrl'],
      questions: json['questions'] != null ? List<Map<String, dynamic>>.from(json['questions']) : null,
    );
  }
}
