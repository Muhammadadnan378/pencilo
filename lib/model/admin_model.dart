import 'package:hive/hive.dart';

part 'admin_model.g.dart'; // To generate the Hive adapter

@HiveType(typeId: 3) // Give a unique typeId for your model (must be unique across all your Hive models)
class AdminModel {

  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String phoneNumber;

  @HiveField(2)
  final String fullName;

  @HiveField(3)
  bool? isAdmin = true;

  AdminModel({
    required this.uid,
    required this.phoneNumber,
    required this.fullName,
    this.isAdmin,
});

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    return AdminModel(
      uid: map['uid'],
      phoneNumber: map['phoneNumber'],
      fullName: map['fullName']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
    };
  }
}
