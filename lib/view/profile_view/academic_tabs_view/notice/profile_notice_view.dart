import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/model/notice_&_homework_model.dart';
import 'package:pencilo/view/profile_view/academic_tabs_view/notice/notice_watch_view.dart';

import '../../../../controller/profile_controller.dart';
import '../../../../data/consts/const_import.dart';

class ProfileNoticeView extends StatelessWidget {
  ProfileNoticeView({super.key});

  final ProfileController controller = Get.put(ProfileController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomText(
          text: "Notices",
          color: blackColor,
          fontWeight: FontWeight.bold,
          size: 25,
        )
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection(noticeTableName).where(
              "division", isEqualTo: CurrentUserData.division).where(
              "standard", isEqualTo: CurrentUserData.standard).snapshots(),
          builder: (context, noticeSnapshot) {
            if (noticeSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!noticeSnapshot.hasData) {
              return CustomText(text: "No Notice Found",color: blackColor,);
            }
            if (noticeSnapshot.hasError) {
              return CustomText(text: "Something went wrong",color: blackColor);
            }
            final noticeData = noticeSnapshot.data!.docs;
            return ListView.builder(
              padding: EdgeInsets.only(left: 15, right: 15),
              itemCount: noticeData.length,
              itemBuilder: (context, index) {
                final notice = NoticeHomeWorkModel.fromMap(noticeData[index].data() as Map<String, dynamic>);
                // Select show data
                final isExpanded = controller.showData.contains(notice);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomCard(
                        onTap: () => Get.to(NoticeWatchView(notice: notice)),
                        color: Colors.grey.shade200,
                        borderRadius: 5,
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight * 0.1,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: notice.teacherName,
                                  color: blackColor,
                                  fontWeight: FontWeight.w600,
                                  size: 16,
                                ),
                                SizedBox(height: 10),
                                CustomText(
                                  text: DateFormat.yMMMd().add_jm().format(notice.createdAt),
                                  color: grayColor,
                                ),
                              ],
                            ),
                            Spacer(),
                            CircleAvatar(
                              radius: 25,
                              child: Icon(Icons.person),
                            )
                          ],
                        )
                    ),
                    SizedBox(height: 10),
                  ],
                );
              },
            );
          }
      ),
    );
  }

}
