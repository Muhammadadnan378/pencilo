import '../../../../controller/sell_book_controller.dart';
import '../../../../data/consts/const_import.dart';
import 'my_order_view_tabs/im_buying_view.dart';
import 'my_order_view_tabs/im_selling_view.dart';

class StudentMyBookOrderView extends StatelessWidget {
  StudentMyBookOrderView({super.key});

  final SellBookController controller = Get.put(SellBookController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15,),
        Obx(() {
          controller.isSelectBuying.value;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Column(
                  children: [
                    CustomText(
                      text: "I am Buying",
                      color: controller.isSelectBuying.value == true
                          ? blackColor
                          : grayColor,
                      size: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 3,),
                    controller.isSelectBuying.value == true ? CustomCard(
                      width: 30,
                      height: 2,
                      color: blackColor,
                    ) : SizedBox(),
                  ],
                ),
                onTap: () {
                  controller.isSelectBuying.value = true;
                },
              ),
              SizedBox(width: 10,),
              CustomCard(
                width: 1,
                height: 26,
                color: blackColor,
              ),
              SizedBox(width: 10,),
              GestureDetector(
                child: Column(
                  children: [
                    CustomText(
                      text: "I am Selling",
                      color: controller.isSelectBuying.value == false
                          ? blackColor
                          : grayColor,
                      size: 15,
                      fontWeight: FontWeight.w400,
                    ),
                    controller.isSelectBuying.value == false ? CustomCard(
                      width: 30,
                      height: 2,
                      color: blackColor,
                    ) : SizedBox(),
                  ],
                ),
                onTap: () {
                  controller.isSelectBuying.value = false;
                },
              ),
            ],
          );
        }),
        SizedBox(height: 15,),
        Obx(() =>
        controller.isSelectBuying.value
            ? ImBuyingView()
            : ImSellingView())
      ],
    );
  }
}
