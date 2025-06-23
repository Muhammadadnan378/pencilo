import 'package:flutter/material.dart';
import 'package:pencilo/data/custom_widget/app_logo_widget.dart';
import 'package:pencilo/data/custom_widget/custom_media_query.dart';
import '../data/consts/images.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class WebHomeViews extends StatelessWidget {
  const WebHomeViews({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: isMobile
          ? Drawer(
        backgroundColor: Colors.black87,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: _navItems(isDrawer: true),
        ),
      )
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),

            /// Hero Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40.0, vertical: 30),
              child: isMobile
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _heroText(isMobile),
                  const SizedBox(height: 20),
                  Center(child: Image.asset(startBoyImage, height: 240)),
                ],
              )
                  : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _heroText(isMobile)),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Image.asset(startBoyImage, height: 340),
                    ),
                  ),
                ],
              ),
            ),

            /// Events Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40.0),
              child: Text(
                "Our hosted events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 24 : 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _eventCard(
              image: pubgWebImage,
              title: 'PUBG & Freefire',
              description: 'Our PUBG & Freefire tournament brought together gaming enthusiasts for a thrilling battle royale experience. Players showcased sharp strategy, quick reflexes, and intense teamwork in every match.',
              isReversed: false,
              isMobile: isMobile,
            ),
            _eventCard(
              image: cricketWebImage,
              title: 'Cricket',
              description: 'The cricket match was full of energy and excitement. Teams played with great spirit, giving the audience some truly memorable moments and close finishes.',
              isReversed: true,
              isMobile: isMobile,
            ),
            _eventCard(
              image: kabaddiWebImage,
              title: 'Kabaddi',
              description: 'The kabaddi matches were action-packed and full of strength, skill, and team coordination. It was a great display of traditional sport and raw athleticism.',
              isReversed: false,
              isMobile: isMobile,
            ),
            SizedBox(height: 20,),
            Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Divider(color: Colors.blue, thickness: 1),

                  const SizedBox(height: 24),

                  /// Top Row (Logo + Address + Socials)
                  isMobile
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _logoSection(),
                      const SizedBox(height: 20),
                      _addressSection(TextAlign.center),
                    ],
                  )
                      : Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: Align(alignment: Alignment.centerLeft,child: _logoSection())),
                      Expanded(child: _addressSection(TextAlign.left)),
                    ],
                  ),

                  const SizedBox(height: 32),

                  const Divider(color: Colors.grey, thickness: 0.4),

                  const SizedBox(height: 16),

                  /// Bottom Row
                  isMobile
                      ? Column(
                    children: [
                      _footerLinks(Axis.vertical, CrossAxisAlignment.center),
                      const SizedBox(height: 10),
                      const Text(
                        "Copyright © 2025 • Pencilo pvt ltd.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _footerLinks(Axis.horizontal, CrossAxisAlignment.start),
                      const Text(
                        "Copyright © 2025 • Pencilo pvt ltd.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40.0, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppLogoWidget(
                width: isMobile ? 40 : 50,
                height: isMobile ? 40 : 50,
                imagePath: simpleAppLogo,
              ),
              const SizedBox(width: 10),
              Text(
                "Pencilo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          isMobile
              ? Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          )
              : Row(children: _navItems()),
        ],
      ),
    );
  }

  List<Widget> _navItems({bool isDrawer = false}) {
    const items = ["Home", "Notes", "Buy/Sell", "Services", "Events", "Contacts", "About us"];
    return items.map((item) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDrawer ? 8.0 : 12.0,
          vertical: isDrawer ? 12.0 : 0,
        ),
        child: Text(
          item,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      );
    }).toList();
  }

  Widget _heroText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Pencilo\nYour All-in-One Learning Hub!",
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 28 : 42,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "📚 Learn Better. Compete Smarter. Connect Freely.",
          style: TextStyle(color: Colors.white70, fontSize: isMobile ? 16 : 20),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Join events"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _eventCard({
    required String image,
    required String title,
    required String description,
    required bool isReversed,
    required bool isMobile,
  }) {
    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        image,
        width: isMobile ? double.infinity : 400,
        height: isMobile ? 200 : 260,
        fit: BoxFit.cover,
      ),
    );

    final textSection = Column(
      crossAxisAlignment: isReversed && !isMobile ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: isReversed && !isMobile ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          textAlign: isReversed && !isMobile ? TextAlign.right : TextAlign.left,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40, vertical: 16),
      child: isMobile
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imageWidget,
          const SizedBox(height: 12),
          textSection,
        ],
      )
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isReversed
            ? [Expanded(child: textSection), const SizedBox(width: 24), imageWidget]
            : [imageWidget, const SizedBox(width: 24), Expanded(child: textSection)],
      ),
    );
  }

  Widget _logoSection() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Image.asset(
        simpleAppLogo, // Replace with your logo path
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _addressSection(TextAlign textAlign) {
    return Column(
      crossAxisAlignment: textAlign == TextAlign.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: const [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: Colors.blue, size: 18),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                "204, Vimal yogesh sadan, Ratanbai comp, Thane(W)",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.phone, color: Colors.blue, size: 18),
            SizedBox(width: 6),
            Text("7506885458", style: TextStyle(color: Colors.white)),
          ],
        ),
        SizedBox(height: 8,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Social Media",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 12,),
            Icon(FontAwesomeIcons.instagram, color: Colors.white, size: 18),
            SizedBox(width: 12),
            Icon(FontAwesomeIcons.youtube, color: Colors.white, size: 18),
            SizedBox(width: 12),
            Icon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18),
          ],
        ),
      ],
    );
  }


  Widget _footerLinks(Axis axis, CrossAxisAlignment alignment) {
    const links = [
      "ABOUT US",
      "CONTACT US",
      "HELP",
      "PRIVACY POLICY",
      "DISCLAIMER",
    ];
    return Flex(
      direction: axis,
      crossAxisAlignment: alignment,
      mainAxisAlignment: MainAxisAlignment.center,
      children: links
          .map((link) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: axis == Axis.horizontal ? 12.0 : 0,
          vertical: axis == Axis.vertical ? 6.0 : 0,
        ),
        child: Text(
          link,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ))
          .toList(),
    );
  }


}

