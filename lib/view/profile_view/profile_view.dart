import 'package:intl/intl.dart';
import 'package:pencilo/controller/profile_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/model/student_model.dart';
import 'package:pencilo/model/teacher_model.dart';
import 'package:pencilo/view/profile_view/setting_view/setting_view.dart';

import 'academic_tabs_view/profile_exam_result_view.dart';
import 'academic_tabs_view/profile_home_work_view.dart';
import 'academic_tabs_view/notice/profile_notice_view.dart';
import 'academic_tabs_view/profile_time_table_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileView({super.key});

  // Function to generate and print PDF report card
  @override
  Widget build(BuildContext context) {
    controller.getCurrentUserAttendance();
    controller.getNotice();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              ValueListenableBuilder(
                valueListenable: CurrentUserData.isTeacher ? Hive
                    .box<TeacherModel>(teacherTableName)
                    .listenable()
                    : Hive
                    .box<StudentModel>(studentTableName)
                    .listenable(),
                builder: (context, value, child) {
                  // Check if the value is empty, meaning no user data is stored in Hive yet
                  if (value.isEmpty) {
                    return CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: InkWell(
                        onTap: () {
                          _showProfileBottomSheet(context, null);
                        },
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: AssetImage(
                              startBoyImage), // Default image
                        ),
                      ),
                    );
                  }

                  // Get the profile URL based on the user type (teacher or student)
                  String? profileUrl;
                  String? name;
                  String? phoneNumber;
                  String? dateOfBirth;
                  String? standard;
                  if (CurrentUserData.isTeacher) {
                    // Cast the object to TeacherModel to access profileUrl
                    var teacher = value.getAt(
                        0) as TeacherModel; // Cast to TeacherModel
                    profileUrl = teacher
                        .profileUrl; // Get the profile URL for the teacher
                    name =
                        teacher.fullName; // Get the profile URL for the teacher
                    phoneNumber = teacher
                        .phoneNumber; // Get the profile URL for the teacher
                    dateOfBirth =
                        teacher.dob; // Get the profile URL for the teacher
                  } else if (CurrentUserData.isStudent) {
                    // Cast the object to StudentModel to access profileUrl
                    var student = value.getAt(
                        0) as StudentModel; // Cast to StudentModel
                    name = student.fullName;
                    phoneNumber = student.phoneNumber;
                    profileUrl = student
                        .profileUrl; // Get the profile URL for the student
                    dateOfBirth =
                        student.dob; // Get the profile URL for the teacher
                    standard =
                        student.standard; // Get the profile URL for the teacher
                  }

                  // Format the date of birth if it's available
                  String formattedDob = 'N/A'; // Default text if DOB is not available
                  if (dateOfBirth != null && dateOfBirth.isNotEmpty) {
                    try {
                      // Use intl package to parse the date if it's in DD/MM/YYYY format
                      DateFormat format = DateFormat(
                          "dd/MM/yyyy"); // Specify the custom format
                      DateTime dobDate = format.parse(
                          dateOfBirth); // Parse the date
                      formattedDob =
                      "${dobDate.day}-${dobDate.month.toString().padLeft(
                          2, '0')}-${dobDate.year}";
                    } catch (e) {
                      debugPrint("Error parsing date: $e");
                      formattedDob = 'Invalid Date Format';
                    }
                  }
                  return Stack(
                    children: [
                      CustomCard(
                        width: double.infinity,
                        height: 255,
                        alignment: Alignment.bottomCenter,
                        child: CustomCard(
                          width: double.infinity,
                          height: 220,
                          padding: EdgeInsets.all(16),
                          color: Color(0xff0A3B87),
                          borderRadius: 12,
                          child: Column(
                            children: [
                              SizedBox(height: 27),
                              CustomText(
                                text: name!,
                                color: Colors.white,
                                size: 22,
                                fontFamily: poppinsFontFamily,
                                fontWeight: FontWeight.bold,
                              ),
                              // Check if `standard` is null or empty before displaying
                              standard != null && standard.isNotEmpty
                                  ? CustomText(
                                text: standard,
                                color: Colors.white,
                                fontFamily: interFontFamily,
                              )
                                  : SizedBox(),
                              CustomText(
                                text: phoneNumber!,
                                color: Colors.white,
                                fontFamily: interFontFamily,
                              ),
                              SizedBox(height: 8),
                              formattedDob != "N/A" ? CustomText(
                                text: formattedDob,
                                color: Colors.white,
                                fontFamily: interFontFamily,
                              ) : SizedBox(),
                              SizedBox(height: 10),
                              CustomCard(
                                onTap: () => Get.to(EditProfilePage()),
                                borderRadius: 12,
                                width: 160,
                                height: 40,
                                alignment: Alignment.center,
                                color: Color(0xff9AC3FF),
                                child: CustomText(text: 'Edit Profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            _showProfileBottomSheet(context, profileUrl);
                          },
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 33,
                              backgroundImage: (profileUrl != null &&
                                  profileUrl.isNotEmpty)
                                  ? NetworkImage(profileUrl)
                                  : AssetImage(
                                  startBoyImage), // Use the stored image or the default image
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },),
              SizedBox(height: 20),
              CustomText(
                text: 'Academic Essentials',
                color: Colors.black,
                size: 24,
                fontWeight: FontWeight.bold,
                fontFamily: poppinsFontFamily,
              ),
              SizedBox(height: 5,),
              // Academic Essentials Section
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.7,
                children: [
                  _buildCard(
                    title: "Home Work",
                    icon: Icons.home,
                    onTap: () => Get.to(ProfileHomeWorkView()),
                  ),
                  _buildCard(
                    title: "Check Timetable",
                    icon: Icons.calendar_month,
                    onTap: () => Get.to(ProfileTimeTableView()),
                  ),
                  _buildCard(
                    title: "View Exam Result",
                    icon: Icons.view_day_outlined,
                    onTap: () => Get.to(ProfileExamResultView()),
                  ),
                  Obx(() {
                    controller.totalNotice.value;
                    return _buildCard(
                      title: "Notice",
                      icon: Icons.note_alt,
                      isNotify: true,
                      totalNotification: controller.totalNotice.value,
                      onTap: (){
                        controller.markNoticeAsWatched();
                        Get.to(ProfileNoticeView());
                      },
                    );
                  }),
                ],
              ),
              // Attendance Section
              if(!CurrentUserData.isTeacher)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  CustomText(
                    text: 'This month’s attendance',
                    color: Colors.black,
                    size: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: poppinsFontFamily,
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    controller.presents.value;
                    controller.absents.value;
                    return Row(
                      children: [
                        _buildAttendanceCard(
                            'Present', controller.presents.value, Colors.green),
                        SizedBox(width: 10,),
                        _buildAttendanceCard(
                            'Absent', controller.absents.value, Colors.red),
                      ],
                    );
                  }),
                ],
              ),
            ],
          ),
          SizedBox(height: 15,),
          CustomCard(
            onTap: () => Get.to(SettingView()),
            width: SizeConfig.screenWidth,
            height: 50,
            borderRadius: 4,
            border: Border.all(color: grayColor, width: 0.5),
            child: Row(
              children: [
                SizedBox(width: 15,),
                CustomText(text: "Setting", color: blackColor,size: 16,),
                Spacer(),
                Icon(Icons.settings),
                SizedBox(width: 15,),
              ],
            )

          )
        ],
      ),
    );
  }

  Widget _buildCard(
      {required String title, required IconData icon, Function()? onTap, bool isNotify = false, int? totalNotification}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CustomCard(
            height: 90,
            color: Colors.black,
            // Ensure blackColor is defined or replace with a color value
            borderRadius: 15,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0, bottom: 3),
                        child: CustomText(
                          text: title,
                          size: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 10),
                        child: Icon(icon, size: 29, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if(isNotify && totalNotification != 0)
            Positioned(
                right: 10,
                bottom: 10,
                child: SizedBox(
                  width: 70,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomCard(
                      color: Colors.green,
                      borderRadius: 5,
                      padding: EdgeInsets.only(left: 3, right: 3),
                      child: CustomText(
                        text: "${totalNotification ?? 0}",
                        maxLines: 1,
                      ),
                    ),
                  ),
                )
            ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(String label, String count, Color color) {
    return Expanded(
      child: CustomCard(
        height: 67,
        color: color.withValues(alpha: 0.5),
        borderRadius: 8,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5),
              child: CustomText(
                text: label,
                size: 14,
                color: blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),


            Positioned(
              bottom: 4,
              right: 10,
              child: CustomText(
                text: count,
                size: 20,
                color: blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileBottomSheet(BuildContext context, String? profileUrl) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CustomText(
                      text: "X",
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                      size: 24,
                    ),
                  )),
              // Profile Picture Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: profileUrl == null || profileUrl.isEmpty
                    ? Image.asset(
                  startBoyImage, // Default image
                  width: 230,
                  height: 230,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  profileUrl, // Profile image
                  width: 230,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomCard(
                    onTap: () {
                      // Pick image from gallery and update the profile
                      controller.pickImage(context);
                      Get.back();
                    },
                    alignment: Alignment.center,
                    borderRadius: 25,
                    width: 123,
                    height: 40,
                    border: Border.all(color: Color(0xff0A3B87), width: 0.5),
                    child: CustomText(
                      text: 'Retake',
                      color: Color(0xff0A3B87),
                    ),
                  ),
                  SizedBox(width: 20),
                  CustomCard(
                    onTap: () {
                      Get.back(); // Navigate back
                    },
                    color: Color(0xff0A3B87),
                    alignment: Alignment.center,
                    borderRadius: 25,
                    width: 123,
                    height: 40,
                    border: Border.all(color: blackColor, width: 0.5),
                    child: CustomText(
                      text: 'Ok',
                      color: whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

