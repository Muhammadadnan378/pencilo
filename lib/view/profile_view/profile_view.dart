import 'package:pencilo/controller/profile_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/consts/images.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';

import 'academic_tabs_view/profile_exam_result_view.dart';
import 'academic_tabs_view/profile_home_work_view.dart';
import 'academic_tabs_view/profile_notice_view.dart';
import 'academic_tabs_view/profile_time_table_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  // Function to generate and print PDF report card
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 25),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: Icon(Icons.picture_as_pdf),
              onTap:() => controller.generatePDF(),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Stack(
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
                            text: CurrentUserData.name,
                            color: Colors.white,
                            size: 22,
                            fontFamily: poppinsFontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          CustomText(
                            text: CurrentUserData.standard,
                            color: Colors.white,
                            fontFamily: interFontFamily,
                          ),
                          CustomText(
                            text: CurrentUserData.phoneNumber,
                            color: Colors.white,
                            fontFamily: interFontFamily,
                          ),
                          SizedBox(height: 8),
                          CustomText(
                            text: '05-Oct-2002',
                            color: Colors.white,
                            fontFamily: interFontFamily,
                          ),
                          SizedBox(height: 10),
                          CustomCard(
                            onTap: () => Get.to(EditProfilePage()),
                            borderRadius: 12,
                            width: 160,
                            height: 40,
                            alignment: Alignment.center,
                            child: CustomText(text: 'Edit Profile'),
                            color: Color(0xff9AC3FF),
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
                        _showProfileBottomSheet(context);
                      },
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 33,
                          backgroundImage: AssetImage(startBoyImage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
                crossAxisCount: 2,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.7,
                children: [
                  _buildCard(
                    title: "Home",
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
                  _buildCard(
                    title: "Notice",
                    icon: Icons.note_alt,
                    onTap: () => Get.to(ProfileNoticeView()),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Attendance Section
              CustomText(
                text: 'This month’s attendance',
                color: Colors.black,
                size: 24,
                fontWeight: FontWeight.bold,
                fontFamily: poppinsFontFamily,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  _buildAttendanceCard('Present', 22, Colors.green),
                  SizedBox(width: 10,),
                  _buildAttendanceCard('Absent', 3, Colors.red),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required IconData icon, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        height: 90,
        color: Colors.black,  // Ensure blackColor is defined or replace with a color value
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
                      color: Colors.white,  // Ensure whiteColor is defined or replace with Colors.white
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
    );
  }

  Widget _buildAttendanceCard(String label, int count, Color color) {
    return Expanded(
      child: CustomCard(
        height: 67,
          color: color.withOpacity(0.2),
          borderRadius: 8,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,top: 5),
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
                text: "$count",
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

  void _showProfileBottomSheet(BuildContext context) {
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
              Align(alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CustomText(text: "X",
                      color: blackColor,
                      fontWeight: FontWeight.bold,
                      size: 24,),
                  )
              ),
              // Profile Picture Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  startBoyImage, // Profile image
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
                      // Add Retake action
                    },
                    alignment: Alignment.center,
                    borderRadius: 25,
                    width: 123,
                    height: 40,
                    border: Border.all(color: Color(0xff0A3B87),width: 0.5),
                    child: CustomText(text: 'Retake', color: Color(0xff0A3B87),),
                  ),
                  SizedBox(width: 20),
                  CustomCard(
                    onTap: () {
                      Get.back();
                    },
                    color: Color(0xff0A3B87),
                    alignment: Alignment.center,
                    borderRadius: 25,
                    width: 123,
                    height: 40,
                    border: Border.all(color: blackColor,width: 0.5),
                    child: CustomText(text: 'Ok',color: whiteColor,),
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





//
//
// class StudentProfilePage extends StatefulWidget {
//   const StudentProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _StudentProfilePageState createState() => _StudentProfilePageState();
// }
//
// class _StudentProfilePageState extends State<StudentProfilePage> with SingleTickerProviderStateMixin {
//
//   ProfileController controller = Get.put(ProfileController());
//   late TabController _tabController;
//   bool _isDarkMode = false;
//
//   // Student data model
//
//   // Attendance data
//
//   // Subject marks data
//
//   // Homework list
//   final List<Map<String, dynamic>> _homeworkList = [
//     {
//       'subject': 'Mathematics',
//       'task': 'Solve 10 algebra problems.',
//       'dueDate': '10 March 2025',
//       'isCompleted': true,
//       'icon': Icons.calculate,
//     },
//     {
//       'subject': 'Science',
//       'task': 'Write a report on climate change.',
//       'dueDate': '12 March 2025',
//       'isCompleted': false,
//       'icon': Icons.science,
//     },
//     {
//       'subject': 'English',
//       'task': 'Read chapter 3 and summarize.',
//       'dueDate': '11 March 2025',
//       'isCompleted': true,
//       'icon': Icons.book,
//     },
//     {
//       'subject': 'Hindi',
//       'task': 'Write an essay on \'My Best Friend\'.',
//       'dueDate': '13 March 2025',
//       'isCompleted': false,
//       'icon': Icons.translate,
//     },
//     {
//       'subject': 'Social Studies',
//       'task': 'Prepare a presentation on World War II.',
//       'dueDate': '15 March 2025',
//       'isCompleted': false,
//       'icon': Icons.public,
//     },
//   ];
//
//   // Calculated results
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//
//     // Listen for tab changes to update UI
//     _tabController.addListener(() {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   // Function to toggle theme
//   void _toggleTheme() {
//     setState(() {
//       _isDarkMode = !_isDarkMode;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // Set theme based on dark mode state
//     final ThemeData theme = _isDarkMode
//         ? ThemeData.dark().copyWith(
//       primaryColor: Colors.indigo,
//       colorScheme: const ColorScheme.dark(
//         primary: Colors.indigo,
//         secondary: Colors.indigoAccent,
//       ),
//     )
//         : ThemeData.light().copyWith(
//       primaryColor: Colors.indigo,
//       colorScheme: const ColorScheme.light(
//         primary: Colors.indigo,
//         secondary: Colors.indigoAccent,
//       ),
//     );
//
//     return Theme(
//       data: theme,
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               expandedHeight: 220.0,
//               floating: false,
//               pinned: true,
//               actions: [
//                 IconButton(
//                   icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
//                   onPressed: _toggleTheme,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.picture_as_pdf),
//                   onPressed: controller.generatePDF,
//                 ),
//               ],
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(controller.studentInfo['name'],
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     )),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     _isDarkMode
//                         ? Container(
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Colors.indigo, Colors.black54],
//                         ),
//                       ),
//                     )
//                         : Container(
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [Colors.indigo, Colors.indigoAccent],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 16,
//                       bottom: 70,
//                       child: Hero(
//                         tag: 'profile-image',
//                         child: CircleAvatar(
//                           radius: 40,
//                           backgroundColor: Colors.white,
//                           child: CircleAvatar(
//                             radius: 38,
//                             backgroundImage:
//                             const AssetImage('assets/student_avatar.png'),
//                             onBackgroundImageError: (_, __) {},
//                             child: const Icon(Icons.person,
//                                 size: 40, color: Colors.white70),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(Icons.school, color: Colors.indigo),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   "Academic Details",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 Chip(
//                                   label: Text(
//                                     "Class ${controller.studentInfo['class']} ${controller.studentInfo['section']}",
//                                   ),
//                                   backgroundColor: theme.colorScheme.primary
//                                       .withOpacity(0.1),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             DetailRow(
//                                 icon: Icons.numbers,
//                                 title: "Roll No",
//                                 value: controller.studentInfo['rollNo']),
//                             DetailRow(
//                                 icon: Icons.badge,
//                                 title: "Admission No",
//                                 value: controller.studentInfo['admissionNo']),
//                             DetailRow(
//                                 icon: Icons.calendar_today,
//                                 title: "Date of Birth",
//                                 value: controller.studentInfo['dateOfBirth']),
//                             DetailRow(
//                                 icon: Icons.bloodtype,
//                                 title: "Blood Group",
//                                 value: controller.studentInfo['bloodGroup']),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(Icons.contact_phone,
//                                     color: Colors.indigo),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   "Contact Information",
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             DetailRow(
//                                 icon: Icons.email,
//                                 title: "Email",
//                                 value: controller.studentInfo['email']),
//                             DetailRow(
//                                 icon: Icons.phone,
//                                 title: "Phone",
//                                 value: controller.studentInfo['phone']),
//                             DetailRow(
//                                 icon: Icons.home,
//                                 title: "Address",
//                                 value: controller.studentInfo['address']),
//                             DetailRow(
//                                 icon: Icons.person,
//                                 title: "Parent",
//                                 value: controller.studentInfo['parentName']),
//                             DetailRow(
//                                 icon: Icons.phone_android,
//                                 title: "Parent Phone",
//                                 value: controller.studentInfo['parentPhone']),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _SliverAppBarDelegate(
//                 TabBar(
//                   controller: _tabController,
//                   labelColor: theme.colorScheme.primary,
//                   unselectedLabelColor:
//                   theme.colorScheme.onBackground.withOpacity(0.6),
//                   indicatorColor: theme.colorScheme.primary,
//                   indicatorWeight: 3,
//                   tabs: const [
//                     Tab(icon: Icon(Icons.assessment), text: "Marks"),
//                     Tab(icon: Icon(Icons.calendar_today), text: "Attendance"),
//                     Tab(icon: Icon(Icons.assignment), text: "Homework"),
//                     Tab(icon: Icon(Icons.schedule), text: "Timetable"),
//                   ],
//                 ),
//                 color: theme.scaffoldBackgroundColor,
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height - 100,
//                 child: TabBarView(
//                   controller: _tabController,
//                   children: [
//                     // Marks Tab
//                     _buildMarksTab(),
//
//                     // Attendance Tab
//                     _buildAttendanceTab(),
//
//                     // Homework Tab
//                     _buildHomeworkTab(),
//
//                     // Timetable Tab
//                     _buildTimetableTab(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 300),
//           transitionBuilder: (Widget child, Animation<double> animation) {
//             return ScaleTransition(scale: animation, child: child);
//           },
//           child: _tabController.index == 0
//               ? FloatingActionButton.extended(
//             key: const ValueKey<String>('generate_pdf'),
//             icon: const Icon(Icons.picture_as_pdf),
//             label: const Text("Download Report"),
//             onPressed: controller.generatePDF,
//           )
//               : null,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMarksTab(ProfileController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Overall Performance",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: _getGradeColor(controller.results['grade']),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             "Grade: ${controller.results['grade']}",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     LinearProgressIndicator(
//                       value: double.parse(controller.results['percentage']) / 100,
//                       backgroundColor: Colors.grey[300],
//                       minHeight: 10,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Percentage: ${controller.results['percentage']}%",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Total Marks: ${controller.results['totalMarks']} / ${controller.results['maxMarks']}",
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Subject Breakdown",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.subjectMarks.length,
//               itemBuilder: (context, index) {
//                 final subject = controller.subjectMarks[index];
//                 final percentage =
//                     (subject['totalMarks'] / subject['maxMarks']) * 100;
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor:
//                               subject['color'].withOpacity(0.2),
//                               child: Icon(subject['icon'],
//                                   color: subject['color']),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     subject['subject'],
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   LinearProgressIndicator(
//                                     value: percentage / 100,
//                                     backgroundColor: Colors.grey[300],
//                                     minHeight: 6,
//                                     borderRadius: BorderRadius.circular(3),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 4),
//                               decoration: BoxDecoration(
//                                 color: _getGradeColor(subject['grade']),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 subject['grade'],
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             _buildMarkItem("Theory", subject['theoryMarks']),
//                             _buildMarkItem(
//                                 "Practical", subject['practicalMarks']),
//                             _buildMarkItem("Total", subject['totalMarks'],
//                                 isTotal: true),
//                             _buildMarkItem("Max", subject['maxMarks']),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMarkItem(String label, int value, {bool isTotal = false}) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value.toString(),
//           style: TextStyle(
//             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
//             fontSize: isTotal ? 16 : 14,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAttendanceTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Attendance Summary",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       _buildAttendanceCircle(
//                         "${_attendanceData['percentage']}%",
//                         "Attendance",
//                         _getAttendanceColor(_attendanceData['percentage']),
//                       ),
//                       _buildAttendanceCircle(
//                         "${_attendanceData['daysPresent']}",
//                         "Days Present",
//                         Colors.green,
//                       ),
//                       _buildAttendanceCircle(
//                         "${_attendanceData['totalDays'] - _attendanceData['daysPresent']}",
//                         "Days Absent",
//                         Colors.red,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   LinearProgressIndicator(
//                     value: _attendanceData['percentage'] / 100,
//                     backgroundColor: Colors.grey[300],
//                     minHeight: 10,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Total School Days: ${_attendanceData['totalDays']}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text(
//             "Attendance History",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _attendanceData['history'].length,
//               itemBuilder: (context, index) {
//                 final record = _attendanceData['history'][index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 4),
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: record['isPresent']
//                           ? Colors.green.withOpacity(0.2)
//                           : Colors.red.withOpacity(0.2),
//                       child: Icon(
//                         record['isPresent'] ? Icons.check : Icons.close,
//                         color: record['isPresent'] ? Colors.green : Colors.red,
//                       ),
//                     ),
//                     title: Text(record['date']),
//                     trailing: Text(
//                       record['status'],
//                       style: TextStyle(
//                         color: record['isPresent'] ? Colors.green : Colors.red,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAttendanceCircle(String value, String label, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color.withOpacity(0.2),
//             border: Border.all(color: color, width: 3),
//           ),
//           child: Center(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(label),
//       ],
//     );
//   }
//
//   Widget _buildHomeworkTab() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Homework Summary",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       _buildHomeworkSummaryItem(
//                         _homeworkList.length.toString(),
//                         "Total",
//                         Colors.blue,
//                         Icons.assignment,
//                       ),
//                       const SizedBox(width: 36),
//                       _buildHomeworkSummaryItem(
//                         _homeworkList
//                             .where((hw) => hw['isCompleted'])
//                             .length
//                             .toString(),
//                         "Completed",
//                         Colors.green,
//                         Icons.check_circle,
//                       ),
//                       const SizedBox(width: 36),
//                       _buildHomeworkSummaryItem(
//                         _homeworkList
//                             .where((hw) => !hw['isCompleted'])
//                             .length
//                             .toString(),
//                         "Pending",
//                         Colors.orange,
//                         Icons.pending_actions,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _homeworkList.length,
//               itemBuilder: (context, index) {
//                 final homework = _homeworkList[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     contentPadding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     leading: CircleAvatar(
//                       backgroundColor: Colors.indigo.withOpacity(0.2),
//                       child: Icon(homework['icon'], color: Colors.indigo),
//                     ),
//                     title: Text(
//                       homework['subject'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(homework['task']),
//                         const SizedBox(height: 4),
//                         Row(
//                           children: [
//                             const Icon(Icons.calendar_today,
//                                 size: 14, color: Colors.grey),
//                             const SizedBox(width: 4),
//                             Text(
//                               "Due: ${homework['dueDate']}",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     trailing: Checkbox(
//                       value: homework['isCompleted'],
//                       onChanged: (value) {
//                         setState(() {
//                           homework['isCompleted'] = value;
//                         });
//                       },
//                       activeColor: Colors.green,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHomeworkSummaryItem(
//       String count, String label, Color color, IconData icon) {
//     return Column(
//       children: [
//         Container(
//           width: 60,
//           height: 60,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: color.withOpacity(0.2),
//           ),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(icon, color: color, size: 20),
//                 Text(
//                   count,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(label),
//       ],
//     );
//   }
//
//   Widget _buildTimetableTab() {
//     // Sample timetable data
//     final List<Map<String, dynamic>> timetable = [
//       {
//         'day': 'Monday',
//         'periods': [
//           {
//             'time': '8:00 - 9:00',
//             'subject': 'Mathematics',
//             'teacher': 'Mr. Gupta'
//           },
//           {
//             'time': '9:00 - 10:00',
//             'subject': 'Science',
//             'teacher': 'Mrs. Sharma'
//           },
//           {
//             'time': '10:15 - 11:15',
//             'subject': 'English',
//             'teacher': 'Mr. Kumar'
//           },
//           {
//             'time': '11:15 - 12:15',
//             'subject': 'Social Studies',
//             'teacher': 'Mr. Singh'
//           },
//           {
//             'time': '13:00 - 14:00',
//             'subject': 'Hindi',
//             'teacher': 'Mrs. Verma'
//           },
//           {
//             'time': '14:00 - 15:00',
//             'subject': 'Physical Education',
//             'teacher': 'Mr. Yadav'
//           },
//         ]
//       },
//       {
//         'day': 'Tuesday',
//         'periods': [
//           {
//             'time': '8:00 - 9:00',
//             'subject': 'Science',
//             'teacher': 'Mrs. Sharma'
//           },
//           {
//             'time': '9:00 - 10:00',
//             'subject': 'Mathematics',
//             'teacher': 'Mr. Gupta'
//           },
//           {
//             'time': '10:15 - 11:15',
//             'subject': 'Hindi',
//             'teacher': 'Mrs. Verma'
//           },
//           {
//             'time': '11:15 - 12:15',
//             'subject': 'English',
//             'teacher': 'Mr. Kumar'
//           },
//           {
//             'time': '13:00 - 14:00',
//             'subject': 'Computer Science',
//             'teacher': 'Mr. Mehta'
//           },
//           {'time': '14:00 - 15:00', 'subject': 'Art', 'teacher': 'Mrs. Kapoor'},
//         ]
//       },
//       {
//         'day': 'Wednesday',
//         'periods': [
//           {'time': '8:00 - 9:00', 'subject': 'English', 'teacher': 'Mr. Kumar'},
//           {'time': '9:00 - 10:00', 'subject': 'Hindi', 'teacher': 'Mrs. Verma'},
//           {
//             'time': '10:15 - 11:15',
//             'subject': 'Mathematics',
//             'teacher': 'Mr. Gupta'
//           },
//           {
//             'time': '11:15 - 12:15',
//             'subject': 'Science',
//             'teacher': 'Mrs. Sharma'
//           },
//           {
//             'time': '13:00 - 14:00',
//             'subject': 'Social Studies',
//             'teacher': 'Mr. Singh'
//           },
//           {'time': '14:00 - 15:00', 'subject': 'Music', 'teacher': 'Mrs. Roy'},
//         ]
//       },
//       {
//         'day': 'Thursday',
//         'periods': [
//           {
//             'time': '8:00 - 9:00',
//             'subject': 'Social Studies',
//             'teacher': 'Mr. Singh'
//           },
//           {
//             'time': '9:00 - 10:00',
//             'subject': 'English',
//             'teacher': 'Mr. Kumar'
//           },
//           {
//             'time': '10:15 - 11:15',
//             'subject': 'Science',
//             'teacher': 'Mrs. Sharma'
//           },
//           {
//             'time': '11:15 - 12:15',
//             'subject': 'Hindi',
//             'teacher': 'Mrs. Verma'
//           },
//           {
//             'time': '13:00 - 14:00',
//             'subject': 'Mathematics',
//             'teacher': 'Mr. Gupta'
//           },
//           {
//             'time': '14:00 - 15:00',
//             'subject': 'Computer Science',
//             'teacher': 'Mr. Mehta'
//           },
//         ]
//       },
//       {
//         'day': 'Friday',
//         'periods': [
//           {'time': '8:00 - 9:00', 'subject': 'Hindi', 'teacher': 'Mrs. Verma'},
//           {
//             'time': '9:00 - 10:00',
//             'subject': 'Social Studies',
//             'teacher': 'Mr. Singh'
//           },
//           {
//             'time': '10:15 - 11:15',
//             'subject': 'Science',
//             'teacher': 'Mrs. Sharma'
//           },
//           {
//             'time': '11:15 - 12:15',
//             'subject': 'Mathematics',
//             'teacher': 'Mr. Gupta'
//           },
//           {
//             'time': '13:00 - 14:00',
//             'subject': 'English',
//             'teacher': 'Mr. Kumar'
//           },
//           {
//             'time': '14:00 - 15:00',
//             'subject': 'Library',
//             'teacher': 'Mrs. Joshi'
//           },
//         ]
//       },
//     ];
//
//     return DefaultTabController(
//       length: timetable.length,
//       child: Column(
//         children: [
//           TabBar(
//             isScrollable: true,
//             tabs: timetable.map((day) => Tab(text: day['day'])).toList(),
//             labelColor: Theme.of(context).colorScheme.primary,
//             unselectedLabelColor:
//             Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
//             indicatorColor: Theme.of(context).colorScheme.primary,
//           ),
//           Expanded(
//             child: TabBarView(
//               children: timetable.map((day) {
//                 return Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: ListView.builder(
//                     itemCount: day['periods'].length,
//                     itemBuilder: (context, index) {
//                       final period = day['periods'][index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .primary
//                                       .withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Text(
//                                   period['time'],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color:
//                                     Theme.of(context).colorScheme.primary,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       period['subject'],
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       period['teacher'],
//                                       style: TextStyle(
//                                         color: Theme.of(context)
//                                             .colorScheme
//                                             .onBackground
//                                             .withOpacity(0.7),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getGradeColor(String grade) {
//     switch (grade) {
//       case 'A+':
//         return Colors.purple;
//       case 'A':
//         return Colors.blue;
//       case 'B+':
//         return Colors.green;
//       case 'B':
//         return Colors.teal;
//       case 'C':
//         return Colors.orange;
//       case 'D':
//         return Colors.amber;
//       default:
//         return Colors.red;
//     }
//   }
//
//   Color _getAttendanceColor(int percentage) {
//     if (percentage >= 90) {
//       return Colors.green;
//     } else if (percentage >= 75) {
//       return Colors.blue;
//     } else if (percentage >= 60) {
//       return Colors.orange;
//     } else {
//       return Colors.red;
//     }
//   }
// }
//
// // Custom delegate for SliverPersistentHeader
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate(this._tabBar, {required this.color});
//
//   final TabBar _tabBar;
//   final Color color;
//
//   @override
//   double get minExtent => _tabBar.preferredSize.height;
//   @override
//   double get maxExtent => _tabBar.preferredSize.height;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: color,
//       child: _tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return false;
//   }
// }
//
// // Widget for detail rows in cards
// class DetailRow extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String value;
//
//   const DetailRow({
//     Key? key,
//     required this.icon,
//     required this.title,
//     required this.value,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey),
//           const SizedBox(width: 8),
//           Text(
//             "$title:",
//             style: const TextStyle(
//               color: Colors.grey,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
