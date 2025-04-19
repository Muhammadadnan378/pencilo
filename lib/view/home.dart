import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pencilo/data/consts/colors.dart';
import 'package:pencilo/view/play_short_video.dart';
import 'package:pencilo/view/profile_view.dart';
import 'package:pencilo/view/buy_book_view/buy_book.dart';
import '../controller/home_controller.dart';
import 'friend_view.dart';
import 'home_view/home_startup_view.dart';
import 'home_view/home_view.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final List<Widget> _screens = [
    PlayShortVideo(),
    BuyBook(),
    HomeView(),
    FriendsView(),
    StudentProfilePage(),
  ];

  final List<IconData> _icons = const [
    Icons.ondemand_video,
    Icons.menu_book,
    Icons.home,
    Icons.people,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(() {
      return Scaffold(
        body: _screens[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: blackColor,
          selectedItemColor: Color(0xff57A8B8),
          unselectedItemColor: whiteColor,
          iconSize: 26,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => controller.selectedIndex.value = index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: _icons.map((icon) => BottomNavigationBarItem(
            icon: Icon(icon),
            label: '', // No label
          ))
              .toList(),
        ),
      );
    });
  }
}

