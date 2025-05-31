import 'package:hive/hive.dart';

part 'sell_book_model.g.dart'; // To generate the Hive adapter

@HiveType(typeId: 2) // Give a unique typeId for your model (must be unique across all your Hive models)
class SellBookModel {
  @HiveField(0)
  final String bookUid;

  @HiveField(1)
  final String uid;

  @HiveField(2)
  final String bookName;

  @HiveField(3)
  final String amount;

  @HiveField(4)
  final String contactNumber;

  @HiveField(5)
  final List<String> images;

  @HiveField(6)
  final String addedDate;

  @HiveField(7)
  final String oldOrNewBook;

  @HiveField(8)
  final String currentLocation;

  @HiveField(9)
  bool? uploaded = false;

  @HiveField(10)
  bool? uploading = false;

  @HiveField(11)
  List<String>? buyBookUsersList;

  @HiveField(12)
  final String? userName;

  @HiveField(13)
  final String? userContact;

  @HiveField(14)
  final List<String>? storageImagePath;

  @HiveField(15)
  final int? requestCount;

  SellBookModel({
    required this.bookUid,
    required this.uid,
    required this.bookName,
    required this.amount,
    required this.contactNumber,
    required this.images,
    required this.addedDate,
    required this.oldOrNewBook,
    required this.currentLocation,
    this.uploading,
    this.uploaded,
    this.buyBookUsersList,
    this.userName,
    this.userContact,
    this.storageImagePath,
    this.requestCount,
  });

  // Convert Firestore data to SellBookModel
  factory SellBookModel.fromFirestore(Map<String, dynamic> firestore) {
    return SellBookModel(
      bookUid: firestore['bookUid'],
      uid: firestore['uid'],
      bookName: firestore['bookName'],
      amount: firestore['amount'],
      contactNumber: firestore['contactNumber'],
      images: List<String>.from(firestore['images']),
      addedDate: firestore['addedDate'],
      oldOrNewBook: firestore['oldOrNewBook'],
      currentLocation: firestore['currentLocation'],
      userName: firestore['userName'],
      userContact: firestore['userContact'],
      requestCount: firestore['requestCount'],
      storageImagePath: List<String>.from(firestore['storageImagePath']),
      buyBookUsersList: List<String>.from(firestore['buyBookUsersList'] ?? []), // FIXED CAST
    );
  }

  // Convert SellBookModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'bookUid': bookUid,
      'uid': uid,
      'bookName': bookName,
      'amount': amount,
      'contactNumber': contactNumber,
      'images': images,
      'addedDate': addedDate,
      'oldOrNewBook': oldOrNewBook,
      'currentLocation': currentLocation,
      'storageImagePath': storageImagePath,
      'buyBookUsersList': buyBookUsersList,
      'requestCount': requestCount,
    };
  }
}
