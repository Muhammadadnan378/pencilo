import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/view/home_view/subject_parts_view.dart';
import '../../controller/home_view_controller.dart';
import '../../data/consts/images.dart';
import 'add_subjects.dart';

class HomeView extends StatelessWidget {
  HomeViewController controller = Get.put(HomeViewController());
  HomeView({super.key});
  final List<String> classBooks = [
    "Hindi",
    "English",
    "History",
    "Science",
    "Maths",
    "Geography",
  ];
  @override
  Widget build(BuildContext context) {

    return Container(
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.08,),
            Row(
              children: [
                // here i need to show user currentLocation
                Column(
                  children: [
                    CustomText(text: 'Aniket Ganesh',
                      color: blackColor,
                      fontFamily: interFontFamily,
                      size: 8,),
                    SizedBox(height: 5,),
                    CustomCard(
                      alignment: Alignment.center,
                      borderRadius: 100,
                      color: Color(0xff57A8B8),
                      width: 41,
                      height: 41,
                      child: CustomText(text: "AG",
                        size: 20,
                        color: blackColor,
                        fontFamily: nixinOneFontFamily,),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications_rounded,size: 25,))
              ],
            ),
            SizedBox(height: 14,),
            Row(
              children: [
                CustomText(text: 'Subjects',
                  color: blackColor,
                  fontFamily: interFontFamily,
                  size: 22,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(width: 14,),
                Obx(() {
                  return CustomCard(
                    height: 28,
                    borderRadius: 9,
                    border: Border.all(color: bgColor, width: 0.3),
                    child: Row(
                      children: [
                        SizedBox(width: 14),
                        // The DropdownButton that displays the options
                        DropdownButton<String>(
                          value: controller.selectedValue.value, // Display selected value
                          icon: Icon(Icons.arrow_drop_down),
                          underline: SizedBox(), // Remove the default underline
                          onChanged: (String? newValue) {
                            // Update the selected value when an item is selected
                            if (newValue != null) {
                              controller.changeValue(newValue);
                            }
                          },
                          items: <String>['4th', '5th', '6th', '7th', '8th', '9th', '10th',]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: CustomText(
                                text: value,
                                fontFamily: poppinsFontFamily,
                                size: 16,
                                color: bgColor,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }),
                Spacer(),
                CustomCard(
                  alignment: Alignment.center,
                  height: 28,
                  padding: EdgeInsets.only(left: 10,right: 10,top: 3,bottom: 3),
                  borderRadius: 9,
                  onTap: () {
                    Get.to(AddSubjects());
                  },
                  border: Border.all(color: bgColor, width: 0.3),
                  child: CustomText(text: "Add Subjects",color: blackColor,size: 15,),
                )
              ],
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: SizeConfig.screenHeight * 0.7,
              child: ListView.builder(
                itemCount: classBooks.length, // Adjust itemCount as per your subjectParts list
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: CustomCard(
                      onTap: () {
                        Get.to(SubjectPartsView(subject: classBooks[index],colors: controller.curvedCardColors[index],bgColor: controller.bGCardColors[index],),); // Navigate to parts view
                      },
                      width: double.infinity,
                      height: 147, // Reduced height of the CustomCard
                      borderRadius: 12,
                      color: controller.curvedCardColors[index],
                      // bgImage: DecorationImage(image: AssetImage(mathImage),fit: BoxFit.cover),
                      child: Stack(
                        children: [

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                              child: Image.asset(
                                controller.curvedImages[index],  // Replace with your dynamic image for each subject
                                width: double.infinity,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Subject Name and Parts
                          Positioned(
                            left: 12,
                            top: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: classBooks[index],  // Subject Name
                                  fontWeight: FontWeight.w600,
                                  size: 18, // Reduced size for text to match the smaller card
                                  color: whiteColor,  // Or any color to contrast the background
                                ),
                                CustomText(
                                  text: 'Parts 1-4',  // You can dynamically change this based on the subject
                                  fontWeight: FontWeight.w400,
                                  size: 12, // Reduced font size
                                  color: whiteColor,  // Or any color to contrast the background
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
