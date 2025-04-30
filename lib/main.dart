import 'package:firebase_core/firebase_core.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:pencilo/db_helper/model_name.dart';
import 'package:pencilo/firebase_options.dart';
import 'package:pencilo/model/sell_book_model.dart';
import 'package:pencilo/model/student_model.dart';
import 'package:pencilo/model/teacher_model.dart';
import 'package:pencilo/view/splash_view/splash_view.dart';
import 'data/custom_widget/custom_media_query.dart';

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
      SplashView(),
    );
  }
}

// Custom wave clipper class
// class WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();
//     path.lineTo(0, 0);
//     path.quadraticBezierTo(size.width / 4, size.height - 20, size.width / 2, size.height);
//     path.quadraticBezierTo(3 * size.width / 4, size.height + 20, size.width, size.height);
//     path.lineTo(size.width, 0);
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

