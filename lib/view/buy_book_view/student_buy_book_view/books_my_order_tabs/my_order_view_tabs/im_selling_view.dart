import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../controller/sell_book_controller.dart';
import '../../../../../data/consts/const_import.dart';
import '../../../../../data/consts/images.dart';
import '../../../../../db_helper/model_name.dart';
import '../../../../../model/sell_book_model.dart';
import '../../sell_book_view.dart';

class ImSellingView extends StatelessWidget {
  ImSellingView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(sellBookTableName)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No data available.'));
        }

        List<SellBookModel> sellBooks = snapshot.data!.docs
            .map((doc) =>
            SellBookModel.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          itemCount: sellBooks.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final sellBook = sellBooks[index];
            final buyBookUsersList = sellBook.buyBookUsersList;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCard(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    width: double.infinity,
                    color: Colors.grey[200],
                    borderRadius: 12,
                    boxShadow: [
                      BoxShadow(color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3)),
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
                            child: sellBook.images.isNotEmpty
                                ? (sellBook.images[0].startsWith('http') ||
                                sellBook.images[0].startsWith('https')
                                ? Image.network(
                              sellBook.images[0],
                              height: 143,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                                : Image.file(
                              File(sellBook.images[0]),
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
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CustomText(
                            text: sellBook.title,
                            fontWeight: FontWeight.w600,
                            size: 14,
                            color: Colors.black,
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
                                      text: '₹ ${sellBook.amount}',
                                      fontWeight: FontWeight.bold,
                                      size: 13,
                                      color: Colors.black,
                                    ),
                                    CustomText(
                                      text: sellBook.currentLocation,
                                      fontWeight: FontWeight.w300,
                                      size: 11,
                                      maxLines: 1,
                                      color: Colors.black,
                                    ),
                                    SizedBox(height: 3,),
                                    CustomText(
                                      text: sellBook.oldOrNewBook,
                                      fontWeight: FontWeight.w400,
                                      size: 11,
                                      maxLines: 1,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  CustomCard(
                                    onTap: () async{
                                      try {
                                        // Delete the SellBook from Firestore by its document ID
                                        await FirebaseFirestore.instance
                                            .collection(sellBookTableName)
                                            .doc(sellBook.bookUid) // Use the specific document ID for the SellBook
                                            .delete();

                                        Get.snackbar("Success", "Sell book deleted successfully!");
                                      } catch (e) {
                                        Get.snackbar("Error", "Failed to delete sell book: $e");
                                      }
                                    },
                                    width: 73,
                                    height: 33,
                                    color: Color(0xffFF8585),
                                    borderRadius: 10,
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: "Delete",
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  CustomCard(
                                    onTap: () {
                                      Get.to(SellBookView(sellBook: sellBook));
                                    },
                                    width: 73,
                                    height: 33,
                                    color: Color(0xff85B6FF),
                                    borderRadius: 10,
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: "Edit",
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(buyBookUsersList != null)
                    SizedBox(height: 10),
                  if(buyBookUsersList != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: "Book Contact",
                        size: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  if(buyBookUsersList != null)
                    SizedBox(height: 5),
                  if(buyBookUsersList != null)
                    Table(
                      border: TableBorder.all(color: Colors.black, width: 1.0),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                  text: 'Name',
                                  fontWeight: FontWeight.bold,
                                  size: 13,
                                  maxLines: 1,
                                  color: bgColor,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                  text: 'Amount',
                                  fontWeight: FontWeight.bold,
                                  size: 13,
                                  maxLines: 1,
                                  color: bgColor,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                  text: 'Contact',
                                  fontWeight: FontWeight.bold,
                                  size: 13,
                                  maxLines: 1,
                                  color: bgColor,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomText(
                                  text: 'Address',
                                  fontWeight: FontWeight.bold,
                                  size: 13,
                                  maxLines: 1,
                                  color: bgColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (buyBookUsersList != null) ...[
                          for (var user in buyBookUsersList)
                            TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      text: user['userName'] ?? '',
                                      color: Colors.black,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      text: user['userAmount'] ?? '',
                                      color: Colors.black,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      text: user['userContact'] ?? '',
                                      color: Colors.black,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      text: user['userAddress'] ?? '',
                                      color: Colors.black,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
