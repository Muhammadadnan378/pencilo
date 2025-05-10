import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import '../../../../controller/student_home_view_controller.dart';

class AttendanceSubmitView extends StatelessWidget {
  final String classes;
  final String subjects;
  AttendanceSubmitView({super.key, required this.classes, required this.subjects});
  final StudentHomeViewController controller = Get.put(StudentHomeViewController());
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9AC3FF),
        centerTitle: true,
        title: Column(
          children: [
            CustomText(text: "$classes may 2025 V",size:  14,fontWeight: FontWeight.w300,color: blackColor,),
            SizedBox(height: 7,),
            CustomText(text: "Attendance of $classes $subjects",size:  16,fontWeight: FontWeight.w700,color: blackColor,),
          ],
        ),
      ),
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              CustomCard(
                color: Color(0xff9AC3FF),
                height: 22,
                width: double.infinity,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCard(
                    height: 62,
                    width: 62,
                    color: Color(0xff528270),
                    onTap: () {
                    },
                    alignment: Alignment.center,
                    borderRadius: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: "20",color: whiteColor,size: 18,fontWeight: FontWeight.w800,),
                        CustomText(text: "present",color: whiteColor,size: 12,fontWeight: FontWeight.w200,),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  CustomCard(
                    height: 62,
                    width: 62,
                    color: Color(0xff9C2E26),
                    onTap: () {
                    },
                    alignment: Alignment.center,
                    borderRadius: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(text: "40",color: whiteColor,size: 18,fontWeight: FontWeight.w800,),
                        CustomText(text: "Absent",color: whiteColor,size: 12,fontWeight: FontWeight.w200,),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15,),
          Center(child: CustomText(text: "Review or edit Attendance",size:  16,fontWeight: FontWeight.w700,color: blackColor,)),
          SizedBox(height: 10,),
          Row(
            children: [
              SizedBox(width: 15,),
              CustomCard(
                borderRadius: 5,
                color: Color(0xffE8E8E8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            CustomText(text: "Select All",size:  10,fontWeight: FontWeight.w200,color: blackColor,),
                            CustomText(text: "Present",size:  16,fontWeight: FontWeight.w700,color: blackColor,)
                        ],
                      ),
                      SizedBox(width: 5,),
                      Icon(Icons.keyboard_arrow_down_outlined)
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              CustomCard(
                color: Color(0xffE8E8E8),
                height: 40,
                width: 30,
                borderRadius: 5,
                alignment: Alignment.center,
                child: Icon(Icons.arrow_forward_ios,size: 15,),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 7.0,right: 7),
            child: CustomCard(
              height: 35,
              borderRadius: 5,
              color: Color(0xff9AC3FF),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(text: "Name",size:  14,fontWeight: FontWeight.w700,color: blackColor,),
                    CustomText(text: "Roll No.",size:  14,fontWeight: FontWeight.w700,color: blackColor,),
                    CustomText(text: "Status",size:  14,fontWeight: FontWeight.w700,color: blackColor,),
                  ]
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          CustomCard(
            height: SizeConfig.screenHeight * 0.5,
            child: ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var indexStart = index + 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 15),
                          child: Column(
                            children: [
                              Row(
                                  children: [
                                    CustomCard(
                                        alignment: Alignment.center,
                                        width: SizeConfig.screenWidth * 0.3,
                                        child: CustomText(
                                          text: "Muhammad",
                                          size: 14,
                                          fontWeight: FontWeight.w700,
                                          color: blackColor,
                                        )
                                    ),
                                    CustomCard(
                                      alignment: Alignment.center,
                                      width: SizeConfig.screenWidth * 0.3,
                                      child: CustomCard(
                                        borderRadius: 5,
                                        color: Color(0xffD9D9D9),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: CustomText(
                                            text: indexStart <= 9
                                                ? "0$indexStart"
                                                : "$indexStart",
                                            size: 14,
                                            fontWeight: FontWeight.w700,
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Obx(() {
                                      bool present = !controller
                                          .isPresentList[index];
                                      Color activeColor = !present
                                          ? Colors.green
                                          : Color(0xffAC4444);

                                      return GestureDetector(
                                        onTap: () =>
                                            controller.toggleStatus(index),
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: activeColor, width: 2),
                                            borderRadius: BorderRadius.circular(
                                                15),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (!present)
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: activeColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              if (!present)
                                                SizedBox(width: 10),
                                              AnimatedSwitcher(
                                                duration: Duration(
                                                    milliseconds: 300),
                                                child: Text(
                                                  !present ? "Present" : "Absent",
                                                  key: ValueKey(present),
                                                  style: TextStyle(
                                                    color: activeColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              if (present)
                                                SizedBox(width: 10),
                                              if (present)
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 300),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: activeColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ]
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0,right: 20,top: 2),
                                child: Divider(),
                              )
                            ],
                          ),
                        ),
                      ]
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.only(left: 35.0,right: 35),
            child: CustomCard(
              borderRadius: 10,
              color: Color(0xff383838),
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: CustomText(
                text: "Confirm & Submit attendance",
                size:  14,
                fontWeight: FontWeight.w700,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 25,),
        ],
      ),
    );
  }
}
