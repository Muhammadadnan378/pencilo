import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../controller/sell_book_controller.dart';
import '../../../../data/consts/const_import.dart';
import '../../../../data/consts/images.dart';
import '../../../../db_helper/model_name.dart';
import '../../../../model/sell_book_model.dart';
import '../book_detail_view.dart';

class StudentBooksView extends StatelessWidget {
  StudentBooksView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      controller.isSelectBooksView.value;
      return Column(
        children: [
          SizedBox(height: 14),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: 'Buy or sell new and used books',
              color: blackColor,
              fontFamily: interFontFamily,
              size: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              // GridView for displaying books from Hive
              ValueListenableBuilder(
                valueListenable: Hive.box<SellBookModel>(sellBookTableName).listenable(),
                // Listening to the changes in the Hive box
                builder: (BuildContext context, Box<SellBookModel> value, Widget? child) {
                  // Fetching the list of books from Hive
                  final books = value.values.toList();

                  if (books.isEmpty) {
                    return SizedBox();
                  }

                  // Sort books by addedDate in descending order (latest first)
                  books.sort((a, b) {
                    var dateA = DateTime.parse(a.addedDate);
                    var dateB = DateTime.parse(b.addedDate);
                    return dateB.compareTo(
                        dateA); // Sort descending (latest first)
                  });

                  return GridView.builder(
                    itemCount: books.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.66,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final book = books[index];

                      return CustomCard(
                        width: double.infinity,
                        color: Colors.grey[200],
                        borderRadius: 12,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                SizedBox(width: 10,),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(BookDetail(
                                        book: book)); // Navigate to Book Details
                                  },
                                  child: book.images.isNotEmpty
                                      ? (book.images[0].startsWith(
                                      'http') ||
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
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ))
                                      : Image.asset(
                                    'assets/default_image.png',
                                    height: 143,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                CustomText(
                                  text: book.bookName,
                                  fontWeight: FontWeight.w600,
                                  size: 14,
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    // Wrap the column inside Expanded to prevent overflow
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets
                                                .only(left: 4.0),
                                            child: CustomText(
                                              text: '₹ ${book.amount}',
                                              fontWeight: FontWeight.bold,
                                              size: 13,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets
                                                .only(left: 4.0),
                                            child: CustomText(
                                              text: book.currentLocation,
                                              fontWeight: FontWeight.w300,
                                              size: 11,
                                              maxLines: 1,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    CustomText(
                                      text: book.oldOrNewBook,
                                      fontWeight: FontWeight.w400,
                                      size: 12,
                                      maxLines: 1,
                                      color: Colors.black,
                                    )
                                  ],
                                ),

                                SizedBox(height: 4),
                              ],
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: book.uploading == true
                                  ? SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: GestureDetector(
                                    onTap: () {
                                      //true the uploading value in hive
                                      book.uploading = false;
                                      value.put(
                                          book.bookUid, book);
                                    },
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,),
                                  )
                              )
                                  : GestureDetector(
                                  onTap: () {
                                    //true the uploading value in hive
                                    book.uploading = true;
                                    value.put(book.bookUid, book);
                                    controller.storeInFirestore(
                                        book);
                                  },
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  )
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 6,),
              Obx(() {
                controller.searchQuery.value;
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(
                      sellBookTableName).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Center(child: CustomText(
                          text: "No Sell books available",
                          color: blackColor));
                    }

                    // Map Firestore data to SellBookModel
                    var books = snapshot.data!.docs.map((doc) {
                      return SellBookModel.fromFirestore(doc.data() as Map<String, dynamic>);
                    }).toList();

                    // Filter books based on search query
                    if (controller.searchQuery.isNotEmpty) {
                      books = books.where((book) {
                        return book.bookName.toLowerCase().contains(controller.searchQuery);
                      }).toList();
                    }

                    // Sort books by addedDate in descending order (latest first)
                    books.sort((a, b) {
                      var dateA = DateTime.parse(a.addedDate);
                      var dateB = DateTime.parse(b.addedDate);
                      return dateB.compareTo(
                          dateA); // Sort descending (latest first)
                    });

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: (books.length / 2).ceil(), // Each row contains 2 items
                      itemBuilder: (context, rowIndex) {
                        final firstIndex = rowIndex * 2;
                        final secondIndex = firstIndex + 1;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: buildBookItem(context, books[firstIndex]),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: secondIndex < books.length
                                    ? buildBookItem(context, books[secondIndex])
                                    : SizedBox(), // Empty space if item count is odd
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              })
            ],
          ),
        ],
      );
    });
  }

  Widget buildBookItem(BuildContext context, SellBookModel book) {
    return CustomCard(
      color: Colors.grey[200],
      borderRadius: 12,
      boxShadow: [
        BoxShadow(
          color: grayColor,
          blurRadius: 0.5,
          offset: Offset(0, 1),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, right: 6, top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Get.to(BookDetail(book: book)),
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: book.images.isNotEmpty
                        ? (book.images[0].startsWith('http')
                        ? NetworkImage(book.images[0])
                        : FileImage(File(book.images[0])) as ImageProvider)
                        : AssetImage(mathImage),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomText(
              text: book.bookName,
              fontWeight: FontWeight.bold,
              size: 16,
              maxLines: 1,
              color: blackColor,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                CustomText(
                  text: '₹ ${book.amount}',
                  fontWeight: FontWeight.w600,
                  size: 13,
                  color: blackColor,
                ),
                Spacer(),
                CustomText(
                  text: book.oldOrNewBook,
                  size: 12,
                  color: blackColor,
                ),
              ],
            ),
            const SizedBox(height: 2),
            CustomText(
              text: book.currentLocation,
              fontWeight: FontWeight.w300,
              size: 11,
              maxLines: 1,
              color: blackColor,
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

}
