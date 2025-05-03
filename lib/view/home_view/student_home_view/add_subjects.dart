import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/student_home_view_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../data/custom_widget/custom_media_query.dart';

class AddSubjects extends StatelessWidget {
  AddSubjects({super.key});

  final HomeViewController controller = Get.put(HomeViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Subjects"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10),
        children: [
          CustomText(
            text: "Subjects",
            color: blackColor,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
          Row(
            children: [
              Expanded(
                child: _selectSubjectsDropdown(
                  dropdownTitle: "Select Subject",
                  subjects: controller.subjectsList,
                  selectedValue: controller.selectSubjects,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildTextField(
                  "Add Subject Parts",
                  controller.subjectPartsController,
                  keyboardType: TextInputType.number,
                  onChanged: controller.generateSubjectParts,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          CustomText(
            text: "Chapters",
            color: blackColor,
            size: 20,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  "Chapter name",
                  controller.chapterNameController,
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Obx((){
                  controller.selectSubjectParts.value;
                  return _selectSubjectsDropdown(
                    subjects: controller.subjectPartsList,
                    selectedValue: controller.selectSubjectParts,
                    dropdownTitle: "Add Chapter in",
                  );
                }),
              ),
            ],
          ),
          _buildTextField(
            "Question",
            controller.questionController,
            keyboardType: TextInputType.text,
          ),
          _buildTextField(
            "Answer",
            controller.ansController,
            keyboardType: TextInputType.text,
          ),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  "Youtube url",
                  controller.youtubeVideoUrlController,
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(width: 10),
              CustomCard(
                width: 70,
                height: 47,
                color: Color(0xff57A8B8),
                borderRadius: 10,
                onTap: () {
                  controller.pickImage(); // ✅ Call method to select image
                },
                child: Icon(Icons.photo, size: 40),
              ),
            ],
          ),
          Obx(() {
            final image = controller.selectedImage.value;
            return image != null
                ? CustomCard(
              height: 200,
              width: SizeConfig.screenWidth,
              color: Colors.transparent,
              child: Image.file(
                image,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            )
                : SizedBox();
          }),
          SizedBox(height: 20,),
          Obx(() => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(),)
              : CustomCard(
            alignment: Alignment.center,
            height: 47,
            color: Color(0xff57A8B8),
            borderRadius: 10,
            onTap: () {
              controller.addSubjectAndChapter(context);
            },
            child: CustomText(text: "Add chapter",size: 18,fontWeight: FontWeight.bold,color: blackColor,),
          ),),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  // Custom Dropdown with dividers between items
  Widget _selectSubjectsDropdown({
    required List<String> subjects,
    required RxString selectedValue,
    required String dropdownTitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomCard(
        borderRadius: 5,
        height: 47,
        border: Border.all(color: blackColor),
        child: PopupMenuButton<String>(
          color: whiteColor,
          onSelected: (String value) {
            selectedValue.value = value;
          },
          itemBuilder: (BuildContext context) {
            return subjects.map((item) {
              return PopupMenuItem<String>(
                value: item,
                child: Column(
                  children: [
                    Text(item),
                    Divider(),
                  ],
                ),
              );
            }).toList();
          },
          child: Obx(() => Row(
            children: [
              const SizedBox(width: 9),
              CustomText(
                text: selectedValue.value.isEmpty
                    ? dropdownTitle
                    : selectedValue.value,
                color: blackColor,
                size: 16,
                fontWeight: FontWeight.w400,
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down),
              const SizedBox(width: 5),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        void Function(String)? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 47,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5, left: 10),
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: blackColor,
            ),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
