import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../data/consts/const_import.dart';
import '../../../../../data/consts/images.dart';
import '../../../../../data/current_user_data/current_user_Data.dart';
import '../../../../../db_helper/model_name.dart';
import '../../../../../model/sell_book_model.dart';

class ImBuyingView extends StatelessWidget {
  final String currentUserUid = CurrentUserData
      .uid; // Assume CurrentUserData.uid contains the current user's UID.

  // You should replace this with actual fetching of books from Firestore or Hive
  Future<List<SellBookModel>> fetchBooks() async {
    // Example Firestore fetch for books (you should replace this with actual fetch logic)
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
        sellBookTableName).get();
    List<SellBookModel> books = snapshot.docs
        .map((doc) =>
        SellBookModel.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return books;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SellBookModel>>(
      future: fetchBooks(), // Fetch books data from Firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error fetching books"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No books found"));
        }

        // Filter books where the current user's UID exists in buyBookUsersList
        List<SellBookModel> books = snapshot.data!
            .where((book) =>
        book.buyBookUsersList != null &&
            book.buyBookUsersList!.any((user) => user['uid'] == currentUserUid))
            .toList();

        return ListView.builder(
          itemCount: books.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            SellBookModel book = books[index];

            // Find the user data from buyBookUsersList where uid matches currentUserUid
            var userData = book.buyBookUsersList!.firstWhere(
                  (user) => user['uid'] == currentUserUid,
              orElse: () => {}, // Return an empty map if user is not found
            );

            return CustomCard(
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
                      child: book.images.isNotEmpty
                          ? (book.images[0].startsWith('http') ||
                          book.images[0].startsWith('https')
                          ? Image.network(
                        book.images[0],
                        height: 143,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        File(book.images[0]),
                        height: 143,
                        width: 114,
                        fit: BoxFit.cover,
                      ))
                          : Image.asset(
                        mathImage,
                        height: 153,
                        width: 114,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: CustomText(
                      text: book.title,
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
                                text: '₹ ${userData['userAmount'] ?? ""}',
                                fontWeight: FontWeight.bold,
                                size: 13,
                                color: blackColor,
                              ),
                              CustomText(
                                text: book.currentLocation,
                                fontWeight: FontWeight.w300,
                                size: 11,
                                maxLines: 1,
                                color: blackColor,
                              ),
                              CustomText(
                                text: "Payment mode: ${userData['paymentMethod'] ??
                                    'Unknown'}",
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
                          text: book.oldOrNewBook,
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
            );
          },
        );
      },
    );
  }
}
