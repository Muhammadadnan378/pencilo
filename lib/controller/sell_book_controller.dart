import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';  // Import Firebase Storage
import 'package:pencilo/db_helper/model_name.dart';
import '../data/consts/const_import.dart';
import '../model/sell_book_model.dart';

class SellBookController extends GetxController {
  var selectedOption = 'New'.obs;
  var images = <File>[].obs;  // List to store selected images
  var uploading = false.obs;


  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;  // Firebase Storage instance

  void selectOption(String value) {
    selectedOption.value = value;
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
    uploading.value = true;
    try {
      List<String> imageUrls = [];

      // Upload images to Firebase Storage and get the download URLs
      for (var imageFile in book.images) {
        String fileName = '$sellBookModelName/${book.bookUid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot uploadTaskSnapshot = await _firebaseStorage
            .ref(fileName)
            .putFile(File(imageFile));

        String downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Store the book data along with image URLs in Firestore
      await _firestore.collection(sellBookModelName).doc(book.bookUid).set({
        'bookUid': book.bookUid,
        'uid': book.uid,
        'title': book.title,
        'amount': book.amount,
        'address': book.address,
        'contactNumber': book.contactNumber,
        'images': imageUrls,
        'addedDate': book.addedDate,
        'oldOrNewBook': book.oldOrNewBook,
      }).then((_) {
        uploading.value = false;
      });
    } catch (e) {
      uploading.value = false;
      Get.snackbar('Error', 'Failed to upload book: $e');
    }
  }

  // Save book data
  Future<void> saveBook() async {
    String title = titleController.text;
    String amount = amountController.text;
    String address = addressController.text;
    String contactNumber = contactNumberController.text;

    if (title.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter the book title');
      return;
    }
    if (amount.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter the amount');
      return;
    }
    if (address.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter the address');
      return;
    }
    if (contactNumber.isEmpty) {
      Get.snackbar('Validation Error', 'Please enter the contact number');
      return;
    }

    // Create SellBook object
    SellBookModel book = SellBookModel(
      bookUid: DateTime.now().toString(),
      title: title,
      amount: amount,
      address: address,
      contactNumber: contactNumber,
      images: images.map((file) => file.path).toList(),  // Store image file paths
      uid: CurrentUserData.uid,
      addedDate: DateTime.now().toString(),
      oldOrNewBook: selectedOption.value,
    );

    await storeInFirestore(book);  // Upload book data to Firestore

    // Clear data after upload
    clearDataAfterUpload();
  }

  // Method to clear data after successful upload
  void clearDataAfterUpload() {
    images.clear();  // Clear the list of images
    titleController.clear();
    amountController.clear();
    addressController.clear();
    contactNumberController.clear();
    selectedOption.value = 'New';
  }
}



