import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/firebase_options.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/model/student_model.dart';
import 'package:pencilo/model/teacher_model.dart';
import 'package:pencilo/view/home_view/answer_view.dart';
import 'package:pencilo/view/splash_view/splash_view.dart';
import 'controller/home_view_controller.dart';
import 'data/custom_widget/custom_media_query.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'model/subjects_model.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );  // Initialize Firebase

  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(TeacherModelAdapter()); // Register Teacher adapter
  Hive.registerAdapter(StudentModelAdapter()); // Register Student adapter
  Hive.registerAdapter(SellBookModelAdapter()); // Register Student adapter

  await Hive.openBox<TeacherModel>(teacherTableName); // Open a box for teachers
  await Hive.openBox<StudentModel>(studentTableName); // Open a box for students
  await Hive.openBox<SellBookModel>(sellBookTableName); // Open a box for students

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // 👈 call this once
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:
      // SubjectListPage(),
      SplashView(),
    );
  }
}

// Future<Map<String, List<SubjectModel>>> fetchSubjectsFromGithub() async {
//   const url = 'https://raw.githubusercontent.com/Muhammadadnan378/my-json-data/main/data.json';
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     final Map<String, dynamic> jsonData = jsonDecode(response.body);
//
//     final list1 = (jsonData['list1'] as List)
//         .map((item) => SubjectModel.fromChapter(item))
//         .toList();
//
//     final list2 = (jsonData['list2'] as List)
//         .map((item) => SubjectModel.fromChapter(item))
//         .toList();
//
//     return {
//       'List 1': list1,
//       'List 2': list2,
//     };
//   } else {
//     throw Exception('Failed to load subjects');
//   }
// }

class SubjectListPage extends StatelessWidget {
  const SubjectListPage({super.key});

  // Fetch the data from GitHub
  Future<Map<String, dynamic>> fetchData() async {
    const url = 'https://raw.githubusercontent.com/Muhammadadnan378/my-json-data/main/data.json';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subjects')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView(
              children: data.entries.map((listEntry) {
                final listName = listEntry.key;
                final subjects = listEntry.value as List<dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(listName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...subjects.map((subject) {
                      final subjectName = subject['subjectName'];
                      final chapterParts = subject.entries
                          .where((e) => e.key.toString().startsWith('chapter part'));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(subjectName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          ...chapterParts.map((entry) {
                            final partName = entry.key;
                            final chapters = entry.value as List;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0, top: 8),
                                  child: Text(partName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                ),
                                ...chapters.map((chapter) {
                                  return ListTile(
                                    leading: Image.network(
                                      chapter['imgUrl'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                                    ),
                                    title: Text(chapter['chapterName'] ?? 'No Chapter'),
                                    subtitle: Text(chapter['question'] ?? 'No Question'),
                                  );
                                }).toList()
                              ],
                            );
                          }).toList()
                        ],
                      );
                    }).toList()
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}


// class SubjectListPage extends StatelessWidget {
//   const SubjectListPage({super.key});
//
//   Future<Map<String, dynamic>> fetchData() async {
//     const url = 'https://raw.githubusercontent.com/Muhammadadnan378/my-json-data/main/data.json';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Subjects')),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final data = snapshot.data!;
//             return ListView(
//               children: data.entries.map((listEntry) {
//                 final listName = listEntry.key;
//                 final subjects = listEntry.value as List<dynamic>;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Text(listName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     ),
//                     ...subjects.map((subject) {
//                       final subjectName = subject['subjectName'];
//                       final chapterParts = subject.entries
//                           .where((e) => e.key.toString().startsWith('chapter part'));
//
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Text(subjectName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                           ),
//                           ...chapterParts.map((entry) {
//                             final partName = entry.key;
//                             final chapters = entry.value as List;
//
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.only(left: 20.0, top: 8),
//                                   child: Text(partName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//                                 ),
//                                 ...chapters.map((chapter) {
//                                   return ListTile(
//                                     leading: Image.network(
//                                       chapter['imgUrl'],
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                       errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
//                                     ),
//                                     title: Text(chapter['chapterName'] ?? 'No Chapter'),
//                                     subtitle: Text(chapter['question'] ?? 'No Question'),
//                                   );
//                                 }).toList()
//                               ],
//                             );
//                           }).toList()
//                         ],
//                       );
//                     }).toList()
//                   ],
//                 );
//               }).toList(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }



// Future<List<SubjectModel>> fetchSubjectsFromGithub() async {
//   const url = 'https://raw.githubusercontent.com/Muhammadadnan378/my-json-data/main/data.json';
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     final List<dynamic> jsonList = jsonDecode(response.body);
//
//     return jsonList.map((json) => SubjectModel.fromChapter(json)).toList();
//   } else {
//     throw Exception('Failed to load subjects');
//   }
// }

// class SubjectListPage extends StatelessWidget {
//   SubjectListPage({super.key});
//
//   Future<Map<String, dynamic>> fetchData() async {
//     const url = 'https://raw.githubusercontent.com/Muhammadadnan378/my-json-data/main/data.json';
//     final response = await http.get(Uri.parse(url));
//
//
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//   HomeViewController controller = Get.put(HomeViewController());
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Subjects')),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final data = snapshot.data!;
//
//             return ListView(
//               children: data.entries.map((listEntry) {
//                 final listName = listEntry.key;
//                 final subjects = listEntry.value as List<dynamic>;
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Text(listName,
//                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                     ),
//                     ...subjects.map((subject) {
//                       final subjectName = subject['subjectName'];
//                       final chapterParts = (subject as Map<String, dynamic>)
//                           .entries
//                           .where((e) => e.key.toString().startsWith('chapter part'))
//                           .toList();
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Text(subjectName,
//                                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
//                           ),
//                           ...chapterParts.map((entry) {
//                             final partName = entry.key;
//                             final chapters = entry.value as List;
//
//                             final partIndex = int.tryParse(RegExp(r'\d+').stringMatch(partName) ?? '') ?? 0;
//
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 10.0),
//                               child: Column(
//                                 children: [
//                                   Obx(() {
//                                     return CustomCard(
//                                       alignment: Alignment.center,
//                                       width: double.infinity,
//                                       height: 100,
//                                       color: controller.currentIndex.value == partIndex
//                                           ? bgColor
//                                           : whiteColor,
//                                       borderRadius: 10,
//                                       border: Border.all(color: blackColor),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: blackColor,
//                                             spreadRadius: 0.5,
//                                             offset: Offset(0, 4))
//                                       ],
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                         children: [
//                                           CustomText(
//                                             text: partName,
//                                             size: 30,
//                                             color: controller.currentIndex.value == partIndex
//                                                 ? whiteColor
//                                                 : blackColor,
//                                             fontWeight: FontWeight.w500,
//                                             fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
//                                           ),
//                                           Obx(() {
//                                             return InkWell(
//                                               onTap: () {
//                                                 controller.currentIndex.value =
//                                                 controller.currentIndex.value == partIndex
//                                                     ? 0
//                                                     : partIndex;
//                                               },
//                                               child: controller.currentIndex.value == partIndex
//                                                   ? Icon(Icons.remove_circle,
//                                                   size: 50, color: whiteColor)
//                                                   : CustomCard(
//                                                 border: Border.all(color: blackColor),
//                                                 borderRadius: 50,
//                                                 child: Icon(CupertinoIcons.add,
//                                                     size: 50, color: blackColor),
//                                               ),
//                                             );
//                                           }),
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                                   Obx(() {
//                                     if (controller.currentIndex.value != partIndex) return SizedBox();
//
//                                     return CustomCard(
//                                       color: bgColor,
//                                       borderRadius: 10,
//                                       padding: const EdgeInsets.all(20),
//                                       child: ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount: chapters.length,
//                                         itemBuilder: (context, index) {
//                                           final chapter = chapters[index];
//                                           final chapterName = chapter['chapterName'] ?? 'Unnamed';
//                                           final chapterIndex = index + 1;
//
//                                           return GestureDetector(
//                                             onTap: () {
//                                               Get.to(AnswerView(
//                                                 myData: SubjectModel.fromChapter(chapter),
//                                               ));
//                                             },
//                                             child: Column(
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     CustomText(
//                                                       text: "$chapterIndex",
//                                                       size: 20,
//                                                       fontWeight: FontWeight.w500,
//                                                     ),
//                                                     SizedBox(width: 20),
//                                                     CustomText(
//                                                       text: chapterName,
//                                                       size: 14,
//                                                       fontWeight: FontWeight.w500,
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 Divider(color: grayColor, height: 10, thickness: 0.6),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     );
//                                   }),
//                                 ],
//                               ),
//                             );
//                           }).toList()
//                         ],
//                       );
//                     }).toList()
//                   ],
//                 );
//               }).toList(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }



