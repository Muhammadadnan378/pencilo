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
  String? questionsTitle;
  String? questionsImage;
  List<Map<String, dynamic>>? questions; // List to hold multiple questions
  List<Map<String, dynamic>>? subQuestion; // List to hold multiple subQuestion
  List<Map<String, dynamic>>? subAns; // List to hold multiple subQuestion


  SubjectModel({
    this.uid,
    this.subjectId,
    this.subjectName,
    this.subjectParts,
    this.ans,
    this.chapterName,
    this.chapterPart,
    this.question,
    this.subQuestion,
    this.subAns,
    this.chapterId,
    this.questionsTitle,
    this.questionsImage,
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
      questionsImage: json['questionsImage'],
      questionsTitle: json['questionsTitle'],
      youtubeVideoPath: json['youtubeVideoPath'],
      imgUrl: json['imgUrl'],
      questions: json['questions'] != null ? List<Map<String, dynamic>>.from(json['questions']) : null,
      subQuestion: json['subQuestion'] != null ? List<Map<String, dynamic>>.from(json['subQuestion']) : null,
      subAns: json['subAns'] != null ? List<Map<String, dynamic>>.from(json['subAns']) : null,
    );
  }
}
