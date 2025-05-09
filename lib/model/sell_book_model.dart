import 'package:hive/hive.dart';

part 'sell_book_model.g.dart'; // To generate the Hive adapter

@HiveType(typeId: 2) // Give a unique typeId for your model (must be unique across all your Hive models)
class SellBookModel {
  @HiveField(0)
  final String bookUid;

  @HiveField(1)
  final String uid;

  @HiveField(2)
  final String title;

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
  List<Map<String, dynamic>>? buyBookUsersList;

  @HiveField(12)
  final String? userName;

  @HiveField(13)
  final String? userAddress;

  @HiveField(14)
  final String? userContact;

  @HiveField(15)
  final List<String>? storageImagePath;

  SellBookModel({
    required this.bookUid,
    required this.uid,
    required this.title,
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
    this.userAddress,
    this.userContact,
    this.storageImagePath,
  });

  // Convert Firestore data to SellBookModel
  factory SellBookModel.fromFirestore(Map<String, dynamic> firestore) {
    return SellBookModel(
      bookUid: firestore['bookUid'],
      uid: firestore['uid'],
      title: firestore['title'],
      amount: firestore['amount'],
      contactNumber: firestore['contactNumber'],
      images: List<String>.from(firestore['images']),
      addedDate: firestore['addedDate'],
      oldOrNewBook: firestore['oldOrNewBook'],
      currentLocation: firestore['currentLocation'],
      userName: firestore['userName'],
      userAddress: firestore['userAddress'],
      userContact: firestore['userContact'],
      storageImagePath: List<String>.from(firestore['storageImagePath']),
      buyBookUsersList: firestore['buyBookUsersList'] != null ? List<Map<String, dynamic>>.from(firestore['buyBookUsersList']) : null,
    );
  }

  // Convert SellBookModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'bookUid': bookUid,
      'uid': uid,
      'title': title,
      'amount': amount,
      'contactNumber': contactNumber,
      'images': images,
      'addedDate': addedDate,
      'oldOrNewBook': oldOrNewBook,
      'currentLocation': currentLocation,
      'userName': userName,
      'userAddress': userAddress,
      'userContact': userContact,
      'storageImagePath': storageImagePath,
    };
  }
}
