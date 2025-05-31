import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pencilo/model/buying_selling_model.dart';
import '../../../../../data/consts/const_import.dart';
import '../../../../../data/current_user_data/current_user_Data.dart';
import '../../../../../db_helper/model_name.dart';

class ImBuyingView extends StatelessWidget {
  final String currentUserUid = CurrentUserData.uid;

  ImBuyingView({super.key}); // Assume CurrentUserData.uid contains the current user's UID.

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(buyingRequestTableName).where("buyerUid", isEqualTo: CurrentUserData.uid).snapshots(), // Fetch books data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error fetching books"));
        }

        if (!snapshot.hasData) {
          return Center(child: Text("No buy books found"));
        }

        var data = snapshot.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {

            var buyBooks = BuyingSellingModel.fromMap(data[index].data());

            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: CustomCard(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.infinity,
                color: Colors.grey[200],
                borderRadius: 12,
                boxShadow: [
                  BoxShadow(
                    color: grayColor,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        // Get.to(BookDetail(book: book));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10),
                        child: Image.network(
                          buyBooks.bookImage[0],
                          height: 143,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: CustomText(
                        text: buyBooks.bookName ?? "",
                        fontWeight: FontWeight.w600,
                        size: 14,
                        color: blackColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: '₹ ${buyBooks.buyerUserAmount}',
                                  fontWeight: FontWeight.bold,
                                  size: 13,
                                  color: blackColor,
                                ),
                                CustomText(
                                  text: buyBooks.sellerCurrentLocation ?? "",
                                  fontWeight: FontWeight.w300,
                                  size: 11,
                                  maxLines: 1,
                                  color: blackColor,
                                ),
                                CustomText(
                                  text: "Payment mode: ${buyBooks.paymentMethod}",
                                  fontWeight: FontWeight.w500,
                                  size: 11,
                                  maxLines: 1,
                                  color: blackColor,
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          // Access user name from userData
                          CustomText(
                            text: buyBooks.bookOldNew ?? "",
                            size: 12,
                            color: blackColor,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
