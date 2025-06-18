import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/notes_view/create_notes_view.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/events_create_view.dart';
import 'package:pencilo/view/home_view/teacher_home_cards_view/results_view/result_view.dart';
import '../../../controller/home_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../data/consts/images.dart';
import '../../../data/custom_widget/custom_media_query.dart';
import 'attendance_view/attendance_view.dart';

class TeacherHomeView extends StatelessWidget {
  const TeacherHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission();
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.only(left: 15.0,right: 15),
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.07,),
          CustomText(text: 'Hi ${CurrentUserData.name}',
            color: blackColor,
            fontFamily: interFontFamily,
            size: 25,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 14,),
          buildCustomCard(
              onTap: () {
                Get.to(StudentHomeAttendanceView());
              },
              title: "Attendance",
              subtitle: "Take a attendance of your school students",
              image: homeAttendance
          ),
          buildCustomCard(title: "Quiz",subtitle: "Quiz for your students to check their understanding",image: homeQuiz),
          buildCustomCard(
              title: "Events",
              subtitle: "Create global events for students to join in sports, skills, and training.",
              image: homeEvent,
              onTap: () {
                Get.to(CreateEventView());
              }
          ),
          buildCustomCard(title: "Upload",
              subtitle: "Upload educational video like reels and monetized your self ",
              image: homeUpload,

          ),
          buildCustomCard(title: "Assignment",subtitle: "Give a assignments to students to check their understanding",image: homeAssignment),
          buildCustomCard(
              onTap: () => Get.to(ResultView()),
              title: "Results",
              subtitle: "upload student result so that their parents can see the results.",
              image: homeResult
          ),
          buildCustomCard(title: "Notice",
              subtitle: "Send a notice to specific class ",
              image: homeResult,
              onTap: () {
                Get.to(CreateNotesAndHomeWorkView(isHomeWork: false,));
              }
          ),
          buildCustomCard(title: "Home Work",
              subtitle: "Send a home work to specific class ",
              image: homeResult,
              onTap: () {
                Get.to(CreateNotesAndHomeWorkView(isHomeWork: true,));
              }
          ),
        ],
      ),
    );
  }

  Padding buildCustomCard({required String title,required String subtitle,required String image,Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: CustomCard(
        onTap: onTap,
        width: SizeConfig.screenWidth,
        borderRadius: 6,
        padding: EdgeInsets.all(13),
        color: Color(0xffE5E5E5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title,
                    color: blackColor,
                    fontFamily: poppinsFontFamily,
                    size: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 7,),
                  CustomText(
                    text: subtitle,
                    color: Color(0xff666666),
                    fontFamily: poppinsFontFamily,
                    size: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 10,)
          ],
        ),
      ),
    );
  }
}
