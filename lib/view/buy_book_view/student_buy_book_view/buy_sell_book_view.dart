import 'package:flutter/cupertino.dart';
import 'package:pencilo/controller/sell_book_controller.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import 'package:pencilo/view/buy_book_view/student_buy_book_view/sell_book_view.dart';
import '../../../data/consts/images.dart';
import '../../../data/custom_widget/app_logo_widget.dart';
import 'books_my_order_tabs/book_view.dart';
import 'books_my_order_tabs/my_orders_view.dart';

class BuySellBookView extends StatelessWidget {

  BuySellBookView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          debugPrint("object");
        },
        child: CustomCard(
          height: double.infinity,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Obx(() {
                  controller.isBookViewSearching.value;
                  controller.isSelectBooksView.value;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: SizeConfig.screenHeight * 0.08),
                        Column(
                          children: [
                            Padding(
                              padding: controller.isBookViewSearching.value == true ? EdgeInsets.only(
                                  left: 20.0, right: 20, bottom: 20)
                                  : EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  controller.isBookViewSearching.value != true
                                      ? AppLogoWidget(
                                    width: 130,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  )
                                      : SizedBox(),
                                  Spacer(),
                                  PopScope(
                                    onPopInvokedWithResult: (didPop, result) {
                                      debugPrint("object");
                                      if (controller.searchFocusNode.hasFocus) {
                                        controller.searchFocusNode
                                            .unfocus(); // Unfocus the textfield
                                        controller.isBookViewSearching.value =
                                        false;
                                        // return false; // Don't pop the screen
                                      }
                                      // return true; // Allow back navigation
                                    },
                                    child: Obx(() =>
                                    controller.isBookViewSearching.value
                                        ? SizedBox(
                                      height: 40,
                                      width: SizeConfig.screenWidth * 0.8,
                                      child: TextField(
                                        controller: controller.searchController,
                                        focusNode: controller.searchFocusNode,
                                        onChanged: (query) {
                                          controller.searchQuery.value =
                                              query.toLowerCase();
                                          controller.update();
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: GestureDetector(
                                              onTap: () {
                                                controller.isBookViewSearching(
                                                    false);
                                                controller.searchFocusNode
                                                    .unfocus();
                                              },
                                              child: Icon(
                                                  Icons.cancel_outlined)),
                                          contentPadding: EdgeInsets.only(
                                              left: 15, right: 10),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                    )
                                        : CustomCard(
                                      onTap: () {
                                        controller.isBookViewSearching(true);
                                        controller.searchFocusNode
                                            .requestFocus();
                                      },
                                      width: 124,
                                      height: 36,
                                      borderRadius: 20,
                                      color: Color(0xffD9D9D9),
                                      child: Row(
                                        children: [
                                          SizedBox(width: 14),
                                          Icon(CupertinoIcons.search,
                                              size: 18,
                                              color: Color(0xff666666)),
                                          SizedBox(width: 10),
                                          CustomText(
                                            text: 'Search',
                                            color: Color(0xff666666),
                                            fontFamily: poppinsFontFamily,
                                            size: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ],
                                      ),
                                    )),
                                  )
                                ],
                              ),
                            ),
                            CustomCard(
                              borderRadius: 10,
                              color: Color(0xffe0e3e1),
                              width: SizeConfig.screenWidth * 0.8,
                              height: 44,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CustomCard(
                                        alignment: Alignment.center,
                                        borderRadius: 10,
                                        height: double.infinity,
                                        color: controller.isSelectBooksView.value
                                            ? Color(
                                            0xffF6F6F6)
                                            : Colors.transparent,
                                        child: CustomText(
                                          text: "Books",
                                          color: blackColor,
                                          size: 13,
                                          fontWeight: FontWeight.bold,),
                                        onTap: () {
                                          controller.isSelectBooksView.value =
                                          true;
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: CustomCard(
                                          alignment: Alignment.center,
                                          borderRadius: 10,
                                          height: double.infinity,
                                          color: !controller.isSelectBooksView
                                              .value
                                              ? Color(
                                              0xffF6F6F6)
                                              : Colors.transparent,
                                          child: CustomText(
                                            text: "My Order",
                                            color: blackColor,
                                            size: 13,
                                            fontWeight: FontWeight.bold,),
                                          onTap: () {
                                            controller.isSelectBooksView.value = false;
                                          },
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        Obx((){
                          controller.searchQuery.value;
                          return controller.isSelectBooksView.value ? StudentBooksView() : StudentMyBookOrderView();
                        }),

                      ],
                    ),
                  );
                }),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: CustomCard(
                  onTap: () {
                    Get.to(SellBookView());
                  },
                  padding: EdgeInsets.only(right: 12, top: 13, bottom: 13),
                  color: Color(0xff57A8B8),
                  borderRadius: 20,
                  child: Row(
                    children: [
                      SizedBox(width: 14),
                      Icon(
                        CupertinoIcons.add,
                        weight: 0.7,
                        size: 18,
                        color: whiteColor,
                      ),
                      SizedBox(width: 3),
                      CustomText(
                        text: 'Sell book',
                        color: whiteColor,
                        fontFamily: poppinsFontFamily,
                        size: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




