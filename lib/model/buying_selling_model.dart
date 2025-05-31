
class BuyingSellingModel {
  String buyerUid;
  String sellId;
  String buyId;
  String? sellerUid;
  String bookId;
  String dateTime;
  String sellerUserName;
  String buyerUserName;
  String paymentMethod;
  bool sellingRequest;
  String sellerUserAmount;
  String buyerUserAmount;
  String? sellerUserContact;
  String? buyerUserContact;
  String? bookOldNew;
  String? bookName;
  String? sellerCurrentLocation;
  String? buyerCurrentLocation;
  List<String> bookImage;

  // Constructor for initializing the EventModel
  BuyingSellingModel({
    required this.buyerUid,
    required this.sellId,
    required this.buyId,
    this.sellerUid,
    required this.bookId,
    required this.dateTime,
    required this.sellerUserName,
    required this.buyerUserName,
    required this.paymentMethod,
    required this.sellingRequest,
    required this.buyerUserAmount,
    required this.sellerUserAmount,
    this.sellerUserContact,
    this.buyerUserContact,
    required this.bookImage,
    required this.bookOldNew,
    required this.bookName,
    required this.sellerCurrentLocation,
    required this.buyerCurrentLocation,
  });

  // Method to create an EventModel instance from a map
  factory BuyingSellingModel.fromMap(Map<String, dynamic> map) {
    return BuyingSellingModel(
      buyerUid: map['buyerUid'] ?? '',
      buyId: map['buyId'] ?? '',
      sellId: map['sellId'] ?? '',
      sellerUid: map['sellerUid'] ?? '',
      bookId: map['bookId'] ?? '',
      dateTime: map['dateTime'] ?? '',
      sellerUserName: map['sellerUserName'] ?? '',
      buyerUserName: map['buyerUserName'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      sellingRequest: map['sellingRequest'] ?? false,
      buyerUserAmount: map['buyerUserAmount'] ?? '',
      sellerUserAmount: map['sellerUserAmount'] ?? '',
      sellerUserContact: map['sellerUserContact'] ?? '',
      buyerUserContact: map['buyerUserContact'] ?? '',
      bookImage: List<String>.from(map['bookImage'] ?? []), // FIXED CAST
      bookOldNew: map['bookOldNew'] ?? '',
      bookName: map['bookName'] ?? '',
      sellerCurrentLocation: map['sellerCurrentLocation'] ?? '',
      buyerCurrentLocation: map['buyerCurrentLocation'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerUid': buyerUid,
      'sellId': sellId,
      'buyId': buyId,
      'bookId': bookId,
      'sellerUid': sellerUid,
      'dateTime': dateTime,
      'sellerUserName': sellerUserName,
      'buyerUserName': buyerUserName,
      'paymentMethod': paymentMethod,
      'sellingRequest': sellingRequest,
      'buyerUserAmount': buyerUserAmount,
      'sellerUserAmount': sellerUserAmount,
      'sellerUserContact': sellerUserContact,
      'buyerUserContact': buyerUserContact,
      'bookImage': bookImage,
      'bookName': bookName,
      'bookOldNew': bookOldNew,
      'sellerCurrentLocation': sellerCurrentLocation,
      'buyerCurrentLocation': buyerCurrentLocation,
    };
  }
}
