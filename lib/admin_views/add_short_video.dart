import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_dropdown.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import '../controller/admin_controller.dart';
import '../data/consts/images.dart';

class AddShortVideo extends StatelessWidget {
  AddShortVideo({super.key});

  final AdminController adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
            text: 'Upload Short Video', color: blackColor, size: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 47,
              child: CustomTextFormField(
                controller: adminController.videoUrlController,
                hintText: 'Enter video URL',
                keyboardType: TextInputType.url,
                contentPadding: EdgeInsets.only(left: 10),
              ),
            ),
            SizedBox(height: 15),
            Obx(() {
              return adminController.isGlobalVideo.value
                  ? SizedBox() // Hide dropdown if global is selected
                  : SizedBox(
                width: SizeConfig.screenWidth * 0.5,
                child: CustomDropdown(
                  subjects: adminController.standardsList,
                  selectedValue: adminController.selectedStandard,
                  dropdownTitle: "STD",
                ),
              );
            }),
            SizedBox(height: 15),
            Row(
              children: [
                CustomText(text: "All student", size: 16, color: blackColor),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    adminController.isGlobalVideo.value = !adminController.isGlobalVideo.value;
                  },
                  child: Obx(() {
                    adminController.isGlobalVideo.value;
                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.deepPurple.shade700,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: whiteColor,
                        child: CircleAvatar(
                          radius: 6,
                          backgroundColor: adminController.isGlobalVideo.value
                              ? Colors.deepPurple.shade700
                              : whiteColor,
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 10,)
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Obx(() {
                return adminController.isUploading.value
                    ? SizedBox(width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator()))
                    : CustomCard(
                  onTap: adminController.uploadVideo,
                  alignment: Alignment.center,
                  borderRadius: 11,
                  width: double.infinity,
                  height: 57,
                  color: blackColor,
                  boxShadow: [
                    BoxShadow(color: grayColor, blurRadius: 5, offset: const Offset(0, 3))
                  ],
                  child: CustomText(
                    text: "Upload",
                    fontWeight: FontWeight.w500,
                    size: 15,
                    fontFamily: poppinsFontFamily,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
