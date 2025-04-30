import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencilo/model/subjects_model.dart';

import '../data/consts/const_import.dart';
import '../data/current_user_data/current_user_Data.dart';

class HomeViewController extends GetxController {

  @override
  void onInit() {
    super.onInit();
  }

  ///Home view methods
  var selectedValue = '4th'.obs; // Default value

  // Method to change the selected value
  void changeValue(String newValue) {
    selectedValue.value = newValue;
  }

  List<String> curvedImages = [
    'assets/images/hindi_card_curved.png',
    'assets/images/english_card_curved.png',
    'assets/images/maths_card_curved.png',
    'assets/images/history_card_curved.png',
    'assets/images/marathi_card_curved.png',
    'assets/images/geographi_card_curved.png',
    'assets/images/maths_card_curved.png',
  ];

  List<Color> curvedCardColors = [
    Color(0xff091F07),
    Color(0xff45757C),
    Color(0xff1F1F1F),
    Color(0xff770505),
    Color(0xff774B05),
    Color(0xff6F7705),
  ];

  List<Color> bGCardColors = [
    Color(0xff107130),
    Color(0xff149885),
    Color(0xff0F4D67),
    Color(0xff430000),
    Color(0xff433800),
    Color(0xff433800),
  ];


  ///Subject parts view methods
  var isSubjectPartSearching = false.obs;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  // Function to update search query
  void updateSearchQuery(String query) {
    // This will trigger UI updates automatically via GetX
    searchController.text = query;
    update(); // Notify listeners that the state has changed
  }



  /// Answer view methods
  String videoUrlUid = '123456';
  TextEditingController urlController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Store the YouTube URL in Firestore
  Future<void> saveVideoUrl(String subjectId) async {
    try {
      await _firestore.collection('youtube_urls').doc(videoUrlUid).update({
        'videoUrl': urlController.text, // Storing the URL
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to save video URL: $e');
    }
  }

  // Fetch the video URL from Firestore
  Future<String?> getVideoUrl(String subjectId) async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore.collection('answers').doc(subjectId).get();
      return documentSnapshot['videoUrl'] as String?;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch video URL: $e');
      return null;
    }
  }

  ///Add subject view methods
  var selectSubjects = ''.obs;
  var selectSubjectParts = ''.obs;
  var isLoading = false.obs;
  RxInt currentIndex = 0.obs;


  TextEditingController subjectPartsController = TextEditingController();
  TextEditingController chapterNameController = TextEditingController();
  TextEditingController questionController = TextEditingController();
  TextEditingController ansController = TextEditingController();
  TextEditingController youtubeVideoUrlController = TextEditingController();

  final List<String> subjectsList = [
    "Hindi",
    "English",
    "History",
    "Science",
    "Maths",
    "Geography",
  ];

  final RxList<String> subjectPartsList = <String>[].obs;

// Call this whenever user updates subject parts
  void generateSubjectParts(String input) {
    subjectPartsList.clear();

    final count = int.tryParse(input);
    if (count != null && count > 0) {
      for (int i = 1; i <= count; i++) {
        subjectPartsList.add("Subject part $i");
      }
    }
  }

  final Rx<File?> selectedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> addSubjectAndChapter(BuildContext context) async {
    isLoading(true);

    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    String subjectId = DateTime.now().millisecondsSinceEpoch.toString();
    String chapterId = DateTime.now().millisecondsSinceEpoch.toString();

    String uid = CurrentUserData.uid;
    String subjectName = selectSubjects.value;
    String subjectParts = subjectPartsController.text.trim();
    String ans = ansController.text.isNotEmpty ? ansController.text.trim() : "";
    String chapterName = chapterNameController.text.trim();
    String chapterPart = selectSubjectParts.value;
    String question = questionController.text.isNotEmpty ? questionController.text.trim() : "";
    String youtubeVideoPath = youtubeVideoUrlController.text.isNotEmpty ? youtubeVideoUrlController.text.trim() : "";
    File? imageFile = selectedImage.value;
    String imgUrl = '';

    // ✅ Validation
    if (subjectName.isEmpty || chapterName.isEmpty || chapterPart.isEmpty || subjectParts.isEmpty) {
      isLoading(false);
      showSnackbar(context, "Subject name subject parts chapter name chapter part is required.");
      return;
    }

    try {
      // ✅ Upload image if selected
      if (imageFile != null) {
        String fileName = 'chapters/$chapterId.jpg';
        final ref = storage.ref().child(fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        imgUrl = await snapshot.ref.getDownloadURL();
      }

      // ✅ Create subject object with only subject fields
      SubjectModel newSubject = SubjectModel(
        uid: uid,
        subjectId: subjectId,
        subjectName: subjectName,
        subjectParts: subjectParts,
      );

      // ✅ Create chapter object with only chapter fields
      SubjectModel newChapter = SubjectModel(
        ans: ans,
        subjectId: subjectId,
        chapterName: chapterName,
        chapterPart: chapterPart,
        question: question,
        chapterId: chapterId,
        youtubeVideoPath: youtubeVideoPath,
        imgUrl: imgUrl, // ✅ May be empty if no image selected
      );


      await firestore.collection('subjects').doc(subjectName).set(newSubject.toSubjectMap());

      await firestore.collection('subjects').doc(subjectName).collection(chapterPart).doc(chapterId).set(newChapter.toChapterMap());

      showSnackbar(context, "Subject and chapter added successfully");
    } catch (e) {
      showSnackbar(context, "Error adding: $e");
    } finally {
      isLoading(false);
      // ✅ Clear input fields
      ansController.clear();
      questionController.clear();
      youtubeVideoUrlController.clear();
      selectedImage.value = null;
    }
  }


  //create static method to get subjects from firestore
// Return a Stream of QuerySnapshot
  Stream<QuerySnapshot<Map<String, dynamic>>> getSubjects(String subject, String subjectName) {
    final firestore = FirebaseFirestore.instance;
    return firestore.collection(subject).where("subjectName",isEqualTo: subjectName).snapshots(); // Use snapshots() instead of get()
  }
// Return a Stream of chapters for a specific subject
  Stream<QuerySnapshot<Map<String, dynamic>>> getChapter(String partName, String subject) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection('subjects')
        .doc(subject)
        .collection(partName)
        .snapshots(); // 🔄 Use snapshots() for real-time updates
  }



  //create static method to get chapters from firestore



}
