import 'package:flutter/material.dart';
import 'package:pencilo/data/consts/const_import.dart';

import '../../../../data/consts/images.dart';
import '../../../../data/current_user_data/current_user_Data.dart';
import 'attendance_submit_view.dart';

class StudentHomeAttendanceView extends StatelessWidget {
  StudentHomeAttendanceView({super.key});

  //create list of class like 4th 5th 6th and so on
  final List<String> classes = [
    "4th",
    "5th",
    "6th",
    "7th",
    "8th",
    "9th",
  ];

  final List<String> subjects = [
    "'A'",
    "'B'",
    "'C'",
    "'D'",
    "'E'",
    "'F'",
  ];

  final List<Color> bgColors = [
    Color(0xff44AC47),
    Color(0xff2A26FF),
    Color(0xff4488AC),
    Color(0xff4465AC),
    Color(0xffAC4444),
    Color(0xffAC9E44),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Hi ${CurrentUserData.name}",color: blackColor,size: 24,fontWeight: FontWeight.bold,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomCard(
          borderRadius: 6,
          color: Color(0xffE5E5E5),
          child: ListView(
            padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15),
            children: [
              Row(
                children: [
                  Image.asset(homeAttendance),
                  SizedBox(width: 10,),
                  CustomText(text: "Attendance",color: blackColor,size: 20,fontWeight: FontWeight.w400,),
                ],
              ),
              SizedBox(height: 20,),
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.0,
                ),
                itemCount: subjects.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return CustomCard(
                    padding: EdgeInsets.all(2),
                    borderRadius: 5,
                    color: whiteColor,
                    child: CustomCard(
                      color: bgColors[index],
                      onTap: () {
                        Get.to(AttendanceSubmitView(classes: classes[index],subjects: subjects[index],));
                      },
                      alignment: Alignment.center,
                      borderRadius: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(text: classes[index],color: whiteColor,size: 18,),
                          CustomText(text: subjects[index],color: whiteColor,size: 18,),
                        ],
                      ),
                    ),
                  );
                },
              )
            ]
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15.0,bottom: 15),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: blackColor,
          child: Icon(Icons.add,color: whiteColor,),
        ),
      )
    );
  }
}
