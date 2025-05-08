import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';  // Import Firebase Storage
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/view/buy_book_view/buy_sell_book_view.dart';
import '../data/consts/const_import.dart';
import '../db_helper/network_check.dart';
import '../model/sell_book_model.dart';

class SellBookController extends GetxController {

  @override
  void onInit() {
    getFullAddress();
    super.onInit();
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
  bool validatePhoneNumber(BuildContext context) {
    // India phone number validation with required +91 or 91 at the start
    final myPhoneNumber = RegExp(r'^[789]\d{9}$');
    if (!myPhoneNumber.hasMatch(contactNumberController.text)) {
      showSnackbar(context, "Please enter a valid Indian phone number.");
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
    if (!validatePhoneNumber(context)) {
      return false;
    }

    var newBook = SellBookModel(
      bookUid: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID based on the current timestamp
      uid: CurrentUserData.uid,  // You can replace this with actual user ID
      title: title,
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

// Select multiple images from gallery
  Future<void> selectImage() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();

      if (pickedFiles != null) {
        for (var pickedFile in pickedFiles) {
          images.add(File(pickedFile.path));
        }
      } else {
        Get.snackbar('Error', 'No images selected.');
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
      print("upload error ");

      // Set 'uploaded' to true before starting the upload
      book.uploading = false;
      box.put(book.bookUid, book);
      return;
    }
    try {
      List<String> imageUrls = [];

      // Upload images to Firebase Storage and get the download URLs
      for (var imageFile in book.images) {
        String fileName = '$sellBookTableName/${book.bookUid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot uploadTaskSnapshot = await _firebaseStorage
            .ref(fileName)
            .putFile(File(imageFile));

        String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Store the book data along with image URLs in Firestore
      await _firestore.collection(sellBookTableName).doc(book.bookUid).set({
        'bookUid': book.bookUid,
        'uid': book.uid,
        'title': book.title,
        'amount': book.amount,
        'contactNumber': book.contactNumber,
        'images': imageUrls,
        'addedDate': book.addedDate,
        'currentLocation': book.currentLocation,
        'oldOrNewBook': book.oldOrNewBook,
      }).then((_) {
        // delete the book from hive
        var box = Hive.box<SellBookModel>(sellBookTableName);
        box.delete(book.bookUid);
      });
    }on FirebaseException catch (e) {
      book.uploading = false;
      box.put(book.bookUid, book);
      print('Failed to upload book: $e');
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
  }

// Method to extract latitude and longitude from the currentLocation string and get the full address
  Future<void> getFullAddress() async {
    print("Location Hive ${CurrentUserData.currentLocation}");
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
      print('Error getting address: $e');
      currentLocation.value = 'Unable to fetch address'; // Set an error message
    }
  }

}



