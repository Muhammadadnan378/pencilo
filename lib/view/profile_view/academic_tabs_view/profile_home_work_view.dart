import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../controller/profile_controller.dart';
import '../../../data/consts/const_import.dart';
import '../../../data/current_user_data/current_user_Data.dart';
import '../../../db_helper/model_name.dart';
import '../../../model/notice_&_homework_model.dart';
import 'notice/notice_watch_view.dart';

class ProfileHomeWorkView extends StatelessWidget {
  ProfileHomeWorkView({super.key});
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(homeWorkTableName).where(
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
                final homeWorkData = noticeSnapshot.data!.docs;

                int totalCompleteTask = 0;
                int totalPendingTask = 0;

                for (var data in homeWorkData) {
                  var notice = NoticeHomeWorkModel.fromMap(data.data() as Map<String, dynamic>);
                  if (notice.isHomeWorkDon!.contains(CurrentUserData.uid)) {
                    totalCompleteTask += 1;
                  } else {
                    totalPendingTask += 1;
                  }
                }
                return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: whiteColor,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Homework Summary",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildHomeworkSummaryItem(
                                homeWorkData.length.toString(),
                                "Total",
                                Colors.blue,
                                Icons.assignment,
                              ),
                              const SizedBox(width: 36),
                              _buildHomeworkSummaryItem(
                                totalCompleteTask.toString(),
                                "Completed",
                                Colors.green,
                                Icons.check_circle,
                              ),
                              const SizedBox(width: 36),
                              _buildHomeworkSummaryItem(
                                totalPendingTask.toString(),
                                "Pending",
                                Colors.orange,
                                Icons.pending_actions,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: homeWorkData.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var homeWork = NoticeHomeWorkModel.fromMap(homeWorkData[index].data() as Map<String, dynamic>);
                      return GestureDetector(
                        onTap: () {
                          Get.to(NoticeWatchView(notice: homeWork));
                        },
                        child: Card(
                          color: whiteColor,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.withValues(alpha: 0.5),
                              child: CustomText(text: homeWork.teacherName[0],size: 20,),
                            ),
                            title: Text(
                              homeWork.teacherName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                CustomText(text: homeWork.note,color: blackColor,maxLines: 1,),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat.yMMMd().add_jm().format(homeWork.createdAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Checkbox(
                              value: homeWork.isHomeWorkDon!.contains(CurrentUserData.uid),
                              onChanged: (value) {
                                if(homeWork.isHomeWorkDon!.contains(CurrentUserData.uid)){
                                  FirebaseFirestore.instance.collection(homeWorkTableName).doc(homeWork.noticeId).update({
                                    "isHomeWorkDon": FieldValue.arrayRemove([CurrentUserData.uid]),
                                  });
                                }else{
                                  FirebaseFirestore.instance.collection(homeWorkTableName).doc(homeWork.noticeId).update({
                                    "isHomeWorkDon": FieldValue.arrayUnion([CurrentUserData.uid]),
                                  });
                                }
                              },
                              activeColor: Colors.green,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildHomeworkSummaryItem(String count, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.5),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}