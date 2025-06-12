import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_dropdown.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'dart:math';

import '../../../../controller/notice_&_homework_controller.dart';
import '../../../../data/consts/images.dart';
import '../../../../data/current_user_data/current_user_Data.dart';
import '../../../../db_helper/send_notification_service.dart';
import '../../../../model/notice_&_homework_model.dart';

class CreateNotesAndHomeWorkView extends StatelessWidget {
  final bool isHomeWork;
  CreateNotesAndHomeWorkView({super.key, required this.isHomeWork});
  final NotesNHomeWorkController controller = Get.put(NotesNHomeWorkController());

  @override
  Widget build(BuildContext context) {
    controller.isHomeWork(isHomeWork);
    debugPrint("${controller.selectedDivision}");
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: isHomeWork ? "Home Work" : "Notice",
          color: blackColor,
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title input
            CustomCard(
              color: Colors.grey.shade200,
              borderRadius: 5,
              child: CustomTextFormField(
                controller: controller.titleController,
                borderColor: Colors.transparent,
                hintText: 'Title',
                hintStyle: TextStyle(color: Colors.black45),
              ),
            ),
            SizedBox(height: 16),

            // Note input
            CustomCard(
              color: Colors.grey.shade200,
              borderRadius: 5,
              child: CustomTextFormField(
                controller: controller.noteController,
                maxLines: 5,
                hintText: 'Write your ${isHomeWork ? "home work" : " note here..."}',
                hintStyle: TextStyle(color: Colors.black45),
                borderColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 16),

            // Image preview
            Obx(() {
              return controller.selectedImage.value != null
                  ? CustomCard(
                width: double.infinity,
                height: SizeConfig.screenHeight * 0.2,
                child: Image.file(controller.selectedImage.value!, fit: BoxFit.cover),
              )
                  : SizedBox();
            }),

            CustomText(text: "Add Attachment", color: blackColor, fontWeight: FontWeight.bold, size: 20),
            SizedBox(height: 8),

            // Attach icon
            Row(
              children: [
                CustomCard(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Choose Option"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text("Take Photo"),
                              onTap: () {
                                Get.back(); // Close dialog
                                controller.pickImageFromSource(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text("Choose from Gallery"),
                              onTap: () {
                                Get.back(); // Close dialog
                                controller.pickImageFromSource(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                  color: Colors.grey.shade200,
                  borderRadius: 5,
                  width: 40,
                  height: 40,
                  child: Transform.rotate(
                    angle: 30 * pi / 180,
                    child: Icon(Icons.attach_file),
                  ),
                ),
                SizedBox(width: 10),
                CustomText(text: 'Attachment', color: blackColor, fontWeight: FontWeight.w400, size: 16)
              ],
            ),

            SizedBox(height: 16),
            CustomText(text: "Share with", color: blackColor, fontWeight: FontWeight.bold, size: 20),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CustomNoticeDropdown(
                    subjects: controller.standardsList,
                    selectedValues: controller.selectedStandards,
                    dropdownTitle: "STD",
                  ),

                ),
                SizedBox(width: 15,),
                Expanded(
                  child: CustomNoticeDropdown(
                    subjects: controller.divisionsList,
                    selectedValues: controller.selectedDivision,
                    dropdownTitle: "DIV",
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.08,),
            Obx(() =>
            controller.uploadingNotice.value ? SizedBox(width: 50,height: 50,child: Center(child: CircularProgressIndicator()))
                : CustomCard(
              onTap: () async {
                controller.uploadingNotice(true);
                bool isFormValid = await controller.validateForm();

                if (isFormValid) {
                  // Trigger Firebase phone verification
                  await controller.uploadNotice().then((value) {
                    controller.uploadingNotice(false);
                  });
                } else {
                  // Show a message if form is invalid
                  controller.uploadingNotice(false);
                }
              },

              alignment: Alignment.center,
              borderRadius: 11,
              width: double.infinity,
              height: 57,
              color: blackColor,
              boxShadow: [
                BoxShadow(
                    color: grayColor,
                    blurRadius: 5,
                    offset: const Offset(0, 3))
              ],
              child: CustomText(
                text: "Share",
                fontWeight: FontWeight.w700,
                size: 20,
                fontFamily: interFontFamily,
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomNoticeDropdown extends StatelessWidget {
  final List<String> subjects;
  final RxList<String> selectedValues; // Change to list
  final String dropdownTitle;
  final bool? isValidate;

  const CustomNoticeDropdown({
    super.key,
    required this.subjects,
    required this.selectedValues,
    required this.dropdownTitle,
    this.isValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CustomCard(
        borderRadius: 5,
        height: 47,
        border: Border.all(color: isValidate == true ? Colors.red : blackColor),
        child: Obx(() => PopupMenuButton<String>(
          color: whiteColor,
          onSelected: (String value) {
            // ✅ Close keyboard on dropdown selection
            FocusManager.instance.primaryFocus?.unfocus();

            if (selectedValues.contains(value)) {
              selectedValues.remove(value);
            } else {
              selectedValues.add(value);
            }
          },
          itemBuilder: (BuildContext context) {
            return subjects.map((item) {
              return CheckedPopupMenuItem<String>(
                value: item,
                checked: selectedValues.contains(item),
                child: Text(item),
              );
            }).toList();
          },
          child: Row(
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: CustomText(
                        text: selectedValues.isEmpty
                            ? dropdownTitle
                            : selectedValues.join(', '),
                        color: selectedValues.isNotEmpty ? blackColor : grayColor,
                        size: 16,
                        maxLines: 3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_drop_down),
              const SizedBox(width: 5),
            ],
          ),
        )),
      ),
    );
  }
}

