import '../../../../controller/teacher_home_result_controller.dart';
import '../../../../data/consts/const_import.dart';
import 'create_school_tab.dart';
import 'select_result_div_std_view.dart';

class ResultView extends StatelessWidget {
  ResultView({super.key});

  final ResultController controller = Get.put(ResultController());

  @override
  Widget build(BuildContext context) {
    controller.checkCurrentSchoolForm(); // ✅ call once at the top
    debugPrint("${controller.schoolList}");
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() => controller.checkDataLoading.value
          ? Center(child: CircularProgressIndicator())
          : !controller.isCurrentSchoolFormFilled.value
          ? CreateResultFormView(controller: controller)
          : SelectResultDivStdView(controller: controller)),
    );
  }

}
