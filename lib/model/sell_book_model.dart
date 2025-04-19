class SellBookModel {
  final String bookUid;
  final String uid;
  final String title;
  final String amount;
  final String address;
  final String contactNumber;
  final List<String> images;
  final String addedDate;
  final String oldOrNewBook;

  SellBookModel({
    required this.bookUid,
    required this.uid,
    required this.title,
    required this.amount,
    required this.address,
    required this.contactNumber,
    required this.images,
    required this.addedDate,
    required this.oldOrNewBook,
  });

  // Convert Firestore data to SellBookModel
  factory SellBookModel.fromFirestore(Map<String, dynamic> firestore) {
    return SellBookModel(
      bookUid: firestore['bookUid'],
      uid: firestore['uid'],
      title: firestore['title'],
      amount: firestore['amount'],
      address: firestore['address'],
      contactNumber: firestore['contactNumber'],
      images: List<String>.from(firestore['images']),
      addedDate: firestore['addedDate'],
      oldOrNewBook: firestore['oldOrNewBook'],
    );
  }

  // Convert SellBookModel to Firestore format
  Map<String, dynamic> toFirestore() {
    return {
      'bookUid': bookUid,
      'uid': uid,
      'title': title,
      'amount': amount,
      'address': address,
      'contactNumber': contactNumber,
      'images': images,
      'addedDate': addedDate,
      'oldOrNewBook': oldOrNewBook,
    };
  }
}
