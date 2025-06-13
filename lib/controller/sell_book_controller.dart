import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';  // Import Firebase Storage
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/model/buying_selling_model.dart';
import '../data/consts/const_import.dart';
import '../db_helper/network_check.dart';
import '../db_helper/send_notification_service.dart';
import '../model/notice_&_homework_model.dart';
import '../model/sell_book_model.dart';

class SellBookController extends GetxController {

  @override
  void onInit() {
    getFullAddress();
    super.onInit();
  }

  void onDispose() {
    debugPrint("object");
    super.dispose();
  }

  /// Sell book view methods and values
  TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;
  var isBookViewSearching = false.obs;
  RxBool isSelectBooksView = true.obs;
  RxBool isSelectBuying = true.obs;
  FocusNode searchFocusNode = FocusNode();
  var selectedOption = 'New'.obs;
  var images = <File>[].obs;  // List to store selected images
  var updateImageList = [].obs;  // List to store selected images
  var uploading = false.obs;
  var isSelectCashDelivery = true.obs;
  RxString currentLocation = ''.obs; // Observable to store the full address
  var books = <SellBookModel>[].obs;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController currentLocationController = TextEditingController(); // No need to initialize with the RxString

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;  // Firebase Storage instance

  void selectOption(String value) {
    selectedOption.value = value;
  }

// Validate the phone number for Pakistan and India
  bool validatePhoneNumber() {
    // India phone number validation with required +91 or 91 at the start
    final myPhoneNumber = RegExp(r'^[789]\d{9}$');
    if (!myPhoneNumber.hasMatch(contactNumberController.text)) {
      Get.snackbar("Error", "Please enter a valid Indian phone number.");
      return false;
    }

    // Add validation for Pakistan here if needed, or continue for further validation.

    return true; // Return true if phone number is valid
  }


  // Save data to Hive
  saveBook(BuildContext context) async {
    String title = titleController.text;
    String amount = amountController.text;
    String contactNumber = contactNumberController.text;
    String location = currentLocationController.text;

    if (title.isEmpty || amount.isEmpty || contactNumber.isEmpty || location.isEmpty || images.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // Validate phone number for students based on the country
    if (!validatePhoneNumber()) {
      return false;
    }

    var newBook = SellBookModel(
      bookUid: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID based on the current timestamp
      uid: CurrentUserData.uid,  // You can replace this with actual user ID
      bookName: title,
      amount: amount,
      contactNumber: contactNumber,
      images: images.map((file) => file.path).toList(),  // Convert File list to paths
      addedDate: DateTime.now().toString(),
      oldOrNewBook: selectedOption.value,
      currentLocation: location,
      uploaded: false,
      uploading: false
    );

    var box = await Hive.openBox<SellBookModel>(sellBookTableName);
    await box.put(newBook.bookUid, newBook);
    clearDataAfterUpload();
    storeInFirestore(newBook);
    Get.back();  // Close the form or navigate back after saving
  }

  List<String> firestoreImageUrls = [];
  List<String> firestoreStorageImagePath = [];

  Future<void> deleteImageFromFirestoreAndStorage(String bookUid)async{
    // Remove image from Firestore
    for (var item in firestoreImageUrls) {
      await FirebaseFirestore.instance.collection(sellBookTableName).doc(bookUid).update({
        'images': FieldValue.arrayRemove([item]),
      });
    }
    // Delete the image from Firebase Storage
    try {
      for (var item in firestoreStorageImagePath) {
        String fileName = item; // Extract file name from URL
        await FirebaseStorage.instance.ref(fileName).delete();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to delete image from storage: $e");
    }
  }

  updateBook(BuildContext context, SellBookModel book) async {
    String title = titleController.text;
    String amount = amountController.text;
    String contactNumber = contactNumberController.text;
    String location = currentLocationController.text;

    // Check for internet connection
    if (!await NetworkHelper.isInternetAvailable()) {
      Get.snackbar("Error", "Internet connection problem");
      return;
    }

    // Check if all fields are filled
    if (title.isEmpty || amount.isEmpty || contactNumber.isEmpty || location.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // Validate phone number for students based on the country
    if (!validatePhoneNumber()) {
      return;
    }

    try {
      if (firestoreImageUrls.isNotEmpty) {
        await deleteImageFromFirestoreAndStorage(book.bookUid);
      }

      List<String> imageUrls = [];
      List<String> storageImagePath = [];
      for(var item in book.images){
        imageUrls.add(item);
        storageImagePath.add(item);
      }
      // Upload images to Firebase Storage and get the download URLs
      for (var imageFile in images) {
        String fileName = '$sellBookTableName/${CurrentUserData.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot uploadTaskSnapshot = await _firebaseStorage.ref(fileName).putFile(imageFile);
        storageImagePath.add(fileName);
        String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }


      // Store the updated book data in Firestore
      await _firestore.collection(sellBookTableName).doc(book.bookUid).update({
        'bookUid': book.bookUid,
        'uid': book.uid,
        'title': title,  // Use updated title
        'amount': amount, // Use updated amount
        'contactNumber': contactNumber, // Use updated contact number
        'images': imageUrls,  // Updated image URLs
        'addedDate': book.addedDate,
        'currentLocation': location, // Use updated location
        'oldOrNewBook': book.oldOrNewBook,
        'storageImagePath' : storageImagePath
      });

      // Clear data after successful upload
      clearDataAfterUpload();
      uploading(false);
      // Close the form or navigate back after saving
      Get.back();
      Get.snackbar("Success", "Sell book updated successfully!");
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      Get.snackbar("Error", "$e");
      debugPrint('Failed to update book: $e');
    }
  }

// Select multiple images from gallery
  Future<void> selectImage() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();

      for (var pickedFile in pickedFiles) {
        images.add(File(pickedFile.path));
      }
        } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }
// Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        images.add(File(pickedFile.path));  // Add image from camera to images list
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image from camera: $e');
    }
  }
// Store book data in Firestore and upload images to Firebase Storage
  Future<void> storeInFirestore(SellBookModel book) async {
    var box = await Hive.openBox<SellBookModel>(sellBookTableName);
    // Set 'uploaded' to true before starting the upload
    book.uploading = true;
    box.put(book.bookUid, book);

    if (!await NetworkHelper.isInternetAvailable()) {
      debugPrint("upload error ");

      // Set 'uploaded' to true before starting the upload
      book.uploading = false;
      box.put(book.bookUid, book);
      return;
    }
    try {
      List<String> imageUrls = [];
      List<String> storageImagePath = [];

      for (var imageFile in book.images) {
        String fileName = '$sellBookTableName/${CurrentUserData.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot uploadTaskSnapshot = await _firebaseStorage.ref(fileName).putFile(File(imageFile));
        storageImagePath.add(fileName);
        String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      SellBookModel newBook = SellBookModel(
        currentLocation: book.currentLocation,
        uid: book.uid,
        bookName: book.bookName,
        addedDate: book.addedDate,
        amount: book.amount,
        contactNumber: book.contactNumber,
        images: imageUrls,
        oldOrNewBook: book.oldOrNewBook,
        bookUid: book.bookUid,
        storageImagePath: storageImagePath,
        uploading: false,
        uploaded: true,
        buyBookUsersList: [],
        requestCount: 0
      );

      // Store the book data along with image URLs in Firestore
      await _firestore.collection(sellBookTableName).doc(book.bookUid).set(newBook.toFirestore()).then((_) {
        // delete the book from hive
        var box = Hive.box<SellBookModel>(sellBookTableName);
        box.delete(book.bookUid);
      });
    }on FirebaseException catch (e) {
      book.uploading = false;
      box.put(book.bookUid, book);
      debugPrint('Failed to upload book: $e');
    }
  }

// Method to clear data after successful upload
  void clearDataAfterUpload() {
    images.clear();  // Clear the list of images
    titleController.clear();
    amountController.clear();
    currentLocationController.clear();
    contactNumberController.clear();
    selectedOption.value = 'New';
    firestoreImageUrls.clear();
    firestoreStorageImagePath.clear();
    uploading(false);
  }

// Method to extract latitude and longitude from the currentLocation string and get the full address
  Future<void> getFullAddress() async {
    debugPrint("Location Hive ${CurrentUserData.currentLocation}");
    try {
      // Extract latitude and longitude from currentLocation string
      String location = CurrentUserData.currentLocation; // Assuming this is the string you get from Firestore
      List<String> coordinates = location.split(','); // Split by comma
      double latitude = double.parse(coordinates[0].trim()); // Parse latitude
      double longitude = double.parse(coordinates[1].trim()); // Parse longitude

      // Get the list of placemarks (full address) from latitude and longitude
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        // Get the first placemark and format the address
        Placemark placemark = placemarks.first;
        String address = '${placemark.street}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';

        // Set the full address to the observable
        currentLocation.value = address;
        currentLocationController.text = address; // Update the text controller with the fetched address
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      currentLocation.value = 'Unable to fetch address'; // Set an error message
    }
  }

  Future<void> buyMethod(SellBookModel book) async {
    String userAmount = amountController.text; // Replace with actual user name from Firebase or other source
    String userAddress = currentLocationController.text;
    String userContact = contactNumberController.text;
    String paymentMethod = isSelectCashDelivery.value ? "Cash on Delivery" : "Online Payment";
    String time = DateTime.now().toString();
    String sellId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create user data to add to the buyBookUsersList
    BuyingSellingModel userData = BuyingSellingModel(
      buyerUid: CurrentUserData.uid, // Use the current user's UID
      sellerUserName: "",
      buyerUserAmount: userAmount,
      sellerUserAmount: book.amount,
      sellerUserContact: book.contactNumber,
      paymentMethod: paymentMethod,
      sellingRequest: false,
      dateTime: time,
      bookImage: book.images,
      bookOldNew: book.oldOrNewBook,
      bookName: book.bookName,
      sellerCurrentLocation: book.currentLocation,
      bookId: book.bookUid,
      sellerUid: book.uid,
      sellId: "",
      buyId: sellId,
      buyerCurrentLocation: userAddress,
      buyerUserName: CurrentUserData.name,
      buyerUserContact: userContact,
    );
    // Check if the current user is already in the buyBookUsersList
    bool userExists = false;

    final querySnapshot = await FirebaseFirestore.instance
        .collection(buyingRequestTableName)
        .where("uid", isEqualTo: CurrentUserData.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userExists = true;
    }
    // If the user doesn't exist, add their data to the list
    if (!userExists) {
      try {
        // Update the book data in Firestore by adding the new user data to buyBookUsersList
        await FirebaseFirestore.instance.collection(buyingRequestTableName).doc(sellId).set(
            userData.toMap())
            .then((value) {
          amountController.clear();
          currentLocationController.clear();
          contactNumberController.clear();
          isSelectCashDelivery.value = true;

          // After successful update, perform the UI updates
          isSelectBooksView(false);
          isSelectBuying(true);
          uploading(false);
          Get.back();

          // Show success message
          Get.snackbar('Success', 'Purchase completed successfully.');
        });
      } catch (e) {
        uploading(false);
        // Handle any errors that occur during the Firestore update
        Get.snackbar('Error', 'There was an issue processing your purchase.');
      }

      await FirebaseFirestore.instance
          .collection(sellBookTableName)
          .doc(book.bookUid)
          .update({
        'requestCount': FieldValue.increment(1),
        'buyBookUsersList': FieldValue.arrayUnion([CurrentUserData.uid]),
      });


      String pushToken = "";

      try {
        // Query the Firestore collection based on the uid
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(studentTableName)
            .where("uid", isEqualTo: book.uid)
            .get();

        // Check if the document exists
        if (snapshot.docs.isNotEmpty) {
          // Retrieve the first document (assuming uid is unique and only one document matches)
          DocumentSnapshot userDoc = snapshot.docs.first;

          // Get the push token (FCM token) from the document
          pushToken = userDoc['pushToken'];

          // Do something with the push token
          debugPrint("Push Token: $pushToken");

          // You can now use this push token to send notifications via FCM
        } else {
          debugPrint("User not found");
        }
      } catch (e) {
        debugPrint("Error retrieving push token: $e");
      }

      // Send the push notification using the push token
      if (pushToken.isNotEmpty) {
        await SendNotificationService.sendNotificationUsingApi(
          token: pushToken,
          title: "${CurrentUserData.name} want to buy your book",
          body: "Tap to view the notification",
          data: {
            "screen": "NotificationView", // This is for navigation when tapped
          },
        );
      }

    } else {
      // Notify the user that they are already in the list
      Get.snackbar('Already Purchased', 'You have already purchased this book.');
    }
  }

  ///Notification view methods
  RxBool isBuyingLength = false.obs;
  RxBool isSellingLength = false.obs;
  RxMap<String, bool> isLoadingMap = <String, bool>{}.obs;


  //send request
  Future<void> acceptSellingRequest(List<dynamic> data,BuyingSellingModel sellBook) async {
    isLoadingMap[sellBook.buyId] = true; // Start loading
    try {
      var sellId = DateTime.now().millisecondsSinceEpoch.toString();
      var buyBookData = BuyingSellingModel(
          buyerUid: CurrentUserData.uid,
          bookId: sellBook.bookId,
          dateTime: sellBook.dateTime,
          sellerUserName: CurrentUserData.name,
          paymentMethod: sellBook.paymentMethod,
          sellingRequest: true,
          buyerUserAmount: sellBook.buyerUserAmount,
          sellerUserAmount: sellBook.sellerUserAmount,
          sellerUserContact: CurrentUserData.phoneNumber,
          bookImage: sellBook.bookImage,
          bookOldNew: sellBook.bookOldNew,
          bookName: sellBook.bookName,
          sellerCurrentLocation: sellBook.sellerCurrentLocation,
          sellerUid: CurrentUserData.uid,
          sellId: sellId,
          buyId: sellBook.buyId,
          buyerUserName: sellBook.buyerUserName,
          buyerUserContact: sellBook.buyerUserContact,
          buyerCurrentLocation: sellBook.buyerCurrentLocation,
      );


      await FirebaseFirestore.instance.collection(sellingRequestTableName).doc(sellId).set(buyBookData.toMap());

      await FirebaseFirestore.instance.collection(buyingRequestTableName).doc(sellBook.buyId).update({
        'sellingRequest' : true,
        'sellId' : sellId,
        'sellerUid' : CurrentUserData.uid,
      });

      String pushToken = "";

      try {
        // Query the Firestore collection based on the uid
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection(studentTableName)
            .where("uid", isEqualTo: sellBook.buyerUid)
            .get();

        // Check if the document exists
        if (snapshot.docs.isNotEmpty) {
          // Retrieve the first document (assuming uid is unique and only one document matches)
          DocumentSnapshot userDoc = snapshot.docs.first;

          // Get the push token (FCM token) from the document
          pushToken = userDoc['pushToken'];

          // Do something with the push token
          debugPrint("Push Token: $pushToken");

          // You can now use this push token to send notifications via FCM
        } else {
          debugPrint("User not found");
        }
        isLoadingMap[sellBook.buyId] = false; // Start loading
      } catch (e) {
        isLoadingMap[sellBook.buyId] = false;
        debugPrint("Error retrieving push token: $e");
      }

      // Send the push notification using the push token
      if (pushToken.isNotEmpty) {
        await SendNotificationService.sendNotificationUsingApi(
          token: pushToken,
          title: "Your book ${sellBook.bookName} buying request accepted",
          body: "Tap to view the notification",
          data: {
            "screen": "NotificationView", // This is for navigation when tapped
          },
        );
      }

      // // Listen for notification tap and navigate to the screen
      // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //   if (message.data['screen'] == 'NotificationView') {
      //     Get.to(() => NotificationView()); // Navigate to NotificationView screen
      //   }
      // });
      isLoadingMap[sellBook.buyId] = false;
      Get.snackbar("Success", "Request sent successfully!",backgroundColor: whiteColor,colorText: blackColor);
    } catch (e) {
      isLoadingMap[sellBook.buyId] = false;
      debugPrint("Error$e");
      Get.snackbar("Error", "$e");
    }
  }
//Cancel send request
  Future<void> rejectSellingRequest(List<dynamic> data,BuyingSellingModel sellBook) async {
    isLoadingMap[sellBook.buyId] = true;
    if(sellBook.sellingRequest == true){

      try {
        await FirebaseFirestore.instance.collection(buyingRequestTableName).doc(sellBook.buyId).update({
          'sellingRequest' : false
        });

        await FirebaseFirestore.instance.collection(sellingRequestTableName).doc(sellBook.sellId).delete();
        isLoadingMap[sellBook.buyId] = false;
        Get.snackbar("Success", "Request canceled successfully!",backgroundColor: whiteColor,colorText: blackColor);
      } on FirebaseFirestore catch (e) {
        isLoadingMap[sellBook.buyId] = false;
        Get.snackbar("Error", e.toString());
      }
    }
  }

  Future<void> updateRequestCount() async {
    try {
      debugPrint("object");
      final querySnapshot = await FirebaseFirestore.instance
          .collection(sellBookTableName)
          .where('uid', isEqualTo: CurrentUserData.uid) // Filter by current user UID
          .get();

      for (var doc in querySnapshot.docs) {
        await FirebaseFirestore.instance
            .collection(sellBookTableName)
            .doc(doc.id)
            .update({'requestCount': 0}); // or set to 0 if resetting
      }
    } catch (e) {
      debugPrint("Error updating requestCount: $e");
    }
  }

  Future<void> markNotificationsAsWatched() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Fetch and update notice documents
      final noticeQuery = await firestore
          .collection(noticeTableName)
          .where("division", isEqualTo: CurrentUserData.division)
          .where("standard", isEqualTo: CurrentUserData.standard)
          .get();

      for (var doc in noticeQuery.docs) {
        final watchedList = List<String>.from(doc['noticeIsWatched'] ?? []);
        if (!watchedList.contains(CurrentUserData.uid)) {
          await firestore.collection(noticeTableName).doc(doc.id).update({
            'noticeIsWatched': FieldValue.arrayUnion([CurrentUserData.uid])
          });
        }
      }

      // Fetch and update homework documents
      final homeworkQuery = await firestore
          .collection(homeWorkTableName)
          .where("division", isEqualTo: CurrentUserData.division)
          .where("standard", isEqualTo: CurrentUserData.standard)
          .get();

      for (var doc in homeworkQuery.docs) {
        final watchedList = List<String>.from(doc['noticeIsWatched'] ?? []);
        if (!watchedList.contains(CurrentUserData.uid)) {
          await firestore.collection(homeWorkTableName).doc(doc.id).update({
            'noticeIsWatched': FieldValue.arrayUnion([CurrentUserData.uid])
          });
        }
      }
    } catch (e) {
      debugPrint("Error updating watched status: $e");
    }
  }




}



