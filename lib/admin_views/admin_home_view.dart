import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/current_user_data/current_user_Data.dart';
import 'add_short_video.dart';
import 'admin_sell_book_data_view.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: CustomText(text: "Admin",color: blackColor,),
        actions: [
          IconButton(
              onPressed: () {
                CurrentUserData.logout();
              },
              icon: Icon(Icons.login)
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(height: 15,),
            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 10,right: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10
              ),
              children: [
                CustomCard(
                  alignment: Alignment.center,
                  borderRadius: 10,
                  color: Colors.green,
                  onTap: () {
                    Get.to(AdminSellBookDataView());
                  },
                  child: CustomText(text: "Data",size: 30,color: blackColor,fontWeight: FontWeight.bold,),
                ),
                CustomCard(
                  alignment: Alignment.center,
                  borderRadius: 10,
                  color: Colors.green,
                  onTap: () {
                    Get.to(AddShortVideo());
                  },
                  child: CustomText(text: "Short Video",size: 30,color: blackColor,fontWeight: FontWeight.bold,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

