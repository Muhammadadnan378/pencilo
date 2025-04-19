
import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/view/home_view/subject_parts_view.dart';

import '../../data/consts/images.dart';

class HomeView extends StatelessWidget {
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
                CustomCard(
                  height: 28,
                  borderRadius: 9,
                  border: Border.all(color: bgColor,width: 0.3),
                  child: Row(
                    children: [
                      SizedBox(width: 14,),
                      CustomText(
                        text: '4th',
                        fontFamily: poppinsFontFamily,
                        size: 16,
                        color: bgColor,
                        fontWeight: FontWeight.w600,),
                      SizedBox(width: 3,),
                      Icon(Icons.arrow_drop_down),
                      SizedBox(width: 5,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: SizeConfig.screenHeight * 0.7,
              child: GridView.builder(
                itemCount: 6,
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.90, // Adjust for height/width ratio
                ),
                shrinkWrap: true, // Important when used inside a column
                physics: BouncingScrollPhysics(), // Avoid scroll conflict
                itemBuilder: (context, index) {
                  return CustomCard(
                    onTap: () {
                      Get.to(SubjectPartsView(subject: classBooks[index],));
                    },
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[200],
                    borderRadius: 12,
                    boxShadow: [
                      BoxShadow(color: grayColor, blurRadius: 5, offset: Offset(0, 3))
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Image
                        Align(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              mathImage,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: CustomText(
                              text: '${classBooks[index]}',
                              fontWeight: FontWeight.w600,
                              size: 12,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
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
