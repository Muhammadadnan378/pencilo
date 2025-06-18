import 'package:pencilo/data/custom_widget/app_custom_button.dart';
import 'package:pencilo/data/custom_widget/custom_dropdown.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/data/custom_widget/custom_text_field.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/results_view/result_view.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/results_view/submit_result_view.dart';
import '../../../../data/consts/const_import.dart';
import '../../../../data/consts/images.dart';

class SelectResultDivStdView extends StatelessWidget {
  const SelectResultDivStdView({
    super.key,
    required this.controller,
  });

  final SchoolController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16.0, right: 16),
      physics: BouncingScrollPhysics(),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Edit Result Information',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 18,
            ),
            SizedBox(height: 10,),
            CustomCard(
              onTap: () {
                if (controller.schoolList.isNotEmpty) {
                  controller.isCurrentSchoolFormFilled.value = false;
                  controller.isEditing.value = true;
                  controller.schoolId.value = controller.schoolList[0].schoolId;
                  controller.selectedSchoolName.value =
                      controller.schoolList[0].schoolName;
                  controller.contactNumberController.text =
                      controller.schoolList[0].contactNumber;
                  controller.schoolAddressController.text =
                      controller.schoolList[0].schoolAddress;
                  controller.alternativeNumberSchoolController.text =
                      controller.schoolList[0].alternativeNumberSchool;
                  controller.websiteLinkController.text =
                      controller.schoolList[0].websiteLink;
                  controller.schoolLogo.value =
                      controller.schoolList[0].schoolLogo;
                  controller.classTeacherSignature.value =
                      controller.schoolList[0].classTeacherSignature;
                  controller.principalSignature.value =
                      controller.schoolList[0].principalSignature;
                }
              },
              borderRadius: 5,
              color: Colors.grey[300],
              width: 50,
              height: 50,
              child: Image.asset(
                editResultImage,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 15,),
            CustomText(
              text: 'Select Standard ',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 18,
            ),
            SizedBox(height: 10,),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              itemCount: controller.standardsList.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                // final GlobalKey gestureKey = GlobalKey();
                return Stack(
                  children: [
                    Obx(() {
                      controller.selectedStandard.value;
                      return CustomCard(
                        border: Border.all(color: controller.selectedStandard
                            .value != controller.standardsList[index]
                            ? whiteColor
                            : blackColor
                        ),
                        padding: EdgeInsets.all(2),
                        borderRadius: 5,
                        color: whiteColor,
                        child: CustomCard(
                          color: controller.bgColors[index %
                              controller.bgColors.length],
                          onTap: () {
                            controller.selectedStandard.value =
                            controller.standardsList[index];
                            controller.getSubjects();
                          },
                          alignment: Alignment.center,
                          borderRadius: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(text: controller.standardsList[index],
                                  color: whiteColor,
                                  size: 18),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
            SizedBox(height: 15,),
            CustomText(
              text: 'Select DIV ',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 18,
            ),
            SizedBox(height: 10,),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              itemCount: controller.divisionsList.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                // final GlobalKey gestureKey = GlobalKey();
                return Stack(
                  children: [
                    Obx(() {
                      controller.selectedDivision.value;
                      return CustomCard(
                        border: Border.all(
                            color: controller.selectedDivision.value !=
                                controller.divisionsList[index]
                                ? whiteColor
                                : blackColor
                        ),
                        padding: EdgeInsets.all(2),
                        borderRadius: 5,
                        color: whiteColor,
                        child: CustomCard(
                          color: controller.bgColors[index %
                              controller.bgColors.length],
                          onTap: () {
                            controller.selectedDivision.value =
                            controller.divisionsList[index];
                            controller.getSubjects();
                          },
                          alignment: Alignment.center,
                          borderRadius: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                  text: controller.divisionsList[index],
                                  color: whiteColor,
                                  size: 18
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
            SizedBox(height: 15,),
            CustomText(
              text: 'Select Term',
              color: blackColor,
              fontWeight: FontWeight.w400,
              size: 18,
            ),
            SizedBox(height: 10,),
            Obx(() {
              controller.selectedTerm.value;
              return CustomDropdown(
                  subjects: controller.getTermList,
                  selectedValue: controller.selectedTerm,
                  dropdownTitle: "Select Term"
              );
            }),
            SizedBox(height: 20,),
            Obx(() =>
                Form(
                  key: controller.formKey,
                  child: ListView.builder(
                    itemCount: controller.subjectListControllers.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      if(index == 0)
                                        CustomText(
                                          text: 'Subj Names',
                                          color: blackColor,
                                          fontWeight: FontWeight.w700,
                                          size: 15,
                                        ),
                                      SizedBox(height: 7,),
                                      CustomCard(
                                        height: 50,
                                        borderRadius: 5,
                                        color: Colors.grey[300],
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10),
                                              border: InputBorder.none
                                          ),
                                          controller: controller
                                              .subjectListControllers[index],
                                          validator: (value) =>
                                          value!.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      if(index == 0)
                                        CustomText(
                                          text: 'P Marks',
                                          color: blackColor,
                                          fontWeight: FontWeight.w700,
                                          size: 15,
                                        ),
                                      SizedBox(height: 7,),
                                      CustomCard(
                                        borderRadius: 5,
                                        color: Colors.grey[300],
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10),
                                              border: InputBorder.none
                                          ),
                                          controller: controller
                                              .practicalMarksListControllers[index],
                                          keyboardType: TextInputType.number,
                                          validator: (value) =>
                                          value!.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      if(index == 0)
                                        CustomText(
                                          text: 'T Marks',
                                          color: blackColor,
                                          fontWeight: FontWeight.w700,
                                          size: 15,
                                        ),
                                      SizedBox(height: 7,),
                                      CustomCard(
                                        borderRadius: 5,
                                        color: Colors.grey[300],
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: 10),
                                              border: InputBorder.none
                                          ),
                                          controller: controller
                                              .marksListControllers[index],
                                          keyboardType: TextInputType.number,
                                          validator: (value) =>
                                          value!.isEmpty
                                              ? 'Required'
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if(index != 0)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () =>
                                      controller.removeSubjectField(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent,
                                    ),
                                    padding: EdgeInsets.all(6),
                                    child: Icon(
                                        Icons.close, color: Colors.white,
                                        size: 10),
                                  ),
                                ),
                              )
                          ],
                        ),
                      );
                    },
                  ),
                )),
            SizedBox(height: 10,),
            CustomCard(
              color: Colors.grey[300],
              width: SizeConfig.screenWidth,
              height: 50,
              borderRadius: 5,
              alignment: Alignment.center,
              onTap: () {
                controller.addNewSubjectField();
              },
              child: CustomText(
                text: "Add new subject", color: grayColor, size: 17,),
            ),
            SizedBox(height: 60,),
            Obx(() =>
            !controller.isUploadSubjects.value ? AppCustomButton(
              text: "OK",
              onTap: () {
                controller.focusNode.unfocus();
                if (controller.formKey.currentState!.validate() &&
                    controller.selectedDivision.value != "" &&
                    controller.selectedStandard.value != "") {
                  controller.isUploadSubjects.value = true;
                  controller.uploadResultSubjects();
                } else {
                  Get.snackbar("Error", "Fields do not be empty");
                }
              },
            ) : Center(child: CircularProgressIndicator()),),

            SizedBox(height: 40,)
          ]
      ),
    );
  }
}