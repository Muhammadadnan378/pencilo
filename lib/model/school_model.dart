class SchoolModel {
  String schoolName;
  String schoolId;
  String contactNumber;
  String schoolAddress;
  String schoolLogo;
  String classTeacherSignature;
  String principalSignature;
  String alternativeNumberSchool;
  String websiteLink;

  SchoolModel({
    required this.schoolId,
    required this.schoolName,
    required this.contactNumber,
    required this.schoolAddress,
    required this.schoolLogo,
    required this.classTeacherSignature,
    required this.principalSignature,
    required this.alternativeNumberSchool,
    required this.websiteLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'schoolName': schoolName,
      'schoolId': schoolId,
      'contactNumber': contactNumber,
      'schoolAddress': schoolAddress,
      'schoolLogo': schoolLogo,
      'classTeacherSignature': classTeacherSignature,
      'principalSignature': principalSignature,
      'alternativeNumberSchool': alternativeNumberSchool,
      'websiteLink': websiteLink,
    };
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      schoolId: json['schoolId'],
      schoolName: json['schoolName'],
      contactNumber: json['contactNumber'],
      schoolAddress: json['schoolAddress'],
      schoolLogo: json['schoolLogo'],
      classTeacherSignature: json['classTeacherSignature'],
      principalSignature: json['principalSignature'],
      alternativeNumberSchool: json['alternativeNumberSchool'],
      websiteLink: json['websiteLink'],
    );
  }

}
