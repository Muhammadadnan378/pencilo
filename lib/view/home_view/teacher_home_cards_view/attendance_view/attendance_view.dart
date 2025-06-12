import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import '../../../../controller/attendance_controller.dart';
import '../../../../data/consts/images.dart';
import '../../../../data/current_user_data/current_user_Data.dart';
import 'attendance_submit_view.dart';

class StudentHomeAttendanceView extends StatelessWidget {
  StudentHomeAttendanceView({super.key});
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(text: "Hi ${CurrentUserData.name}",color: blackColor,size: 24,fontWeight: FontWeight.bold,),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomCard(
              borderRadius: 6,
              color: Color(0xffE5E5E5),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15,bottom: 20),
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
                    itemCount: controller.standardsList.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      // final GlobalKey gestureKey = GlobalKey();
                      return Stack(
                        children: [
                          CustomCard(
                            padding: EdgeInsets.all(2),
                            borderRadius: 5,
                            color: whiteColor,
                            child: CustomCard(
                              color: controller.bgColors[index % controller.bgColors.length],
                              onTap: () {
                                _showAddClassDialog(context,controller,controller.standardsList[index]);
                              },
                              alignment: Alignment.center,
                              borderRadius: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(text: controller.standardsList[index], color: whiteColor, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ]
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(right: 15.0,bottom: 15),
      //   child: GestureDetector(
      //     onTap: () {
      //       _showAddClassDialog(context,controller);
      //     },
      //     child: CircleAvatar(
      //       radius: 30,
      //       backgroundColor: blackColor,
      //       child: Icon(Icons.add,color: whiteColor,),
      //     ),
      //   ),
      // )
    );
  }

  void _showAddClassDialog(BuildContext context,AttendanceController controller,String standard) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Custom radius
          ),
          backgroundColor: Colors.white, // Background color
          child: SizedBox(
            height: SizeConfig.screenHeight * 0.3,
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              itemCount: controller.standardsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return CustomCard(
                  onTap: () {
                    controller.std = standard;
                    controller.div = controller.divisionsList[index];
                    Get.back();
                    Get.to(AttendanceSubmitView(
                      standard: standard,
                      division: controller.divisionsList[index],
                    ));
                  },
                  alignment: Alignment.center,
                  borderRadius: 5,
                  color: controller.bgColors[index % controller.bgColors.length],
                  width: 30,
                  height: 30,
                  child: CustomText(text: controller.divisionsList[index],size: 20,color: blackColor,),
                );
              },
            ),
          ),
        );
      },
    );
  }
// Menu icon
// Positioned(
//   top: 5,
//   right: 5,
//   child: GestureDetector(
//     key: gestureKey, // ✅ each has its own key now
//     onTap: () async {
//       final RenderBox renderBox = gestureKey.currentContext!.findRenderObject() as RenderBox;
//       final Offset offset = renderBox.localToGlobal(Offset.zero);
//       final Size size = renderBox.size;
//
//       final selected = await showMenu<String>(
//         color: blackColor,
//         context: context,
//         position: RelativeRect.fromLTRB(
//           offset.dx,
//           offset.dy + size.height,
//           offset.dx + size.width,
//           offset.dy,
//         ),
//         items: [
//           PopupMenuItem<String>(
//             height: 10,
//             value: 'delete',
//             child: CustomText(text: 'Delete'),
//           ),
//         ],
//       );
//
//       if (selected == 'delete') {
//         await controller.deleteClass(docs[index].id);
//       }
//     },
//     child: Icon(Icons.more_vert_outlined, size: 20,color: whiteColor,),
//   ),
// ),

}
