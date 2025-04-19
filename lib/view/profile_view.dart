import 'package:flutter/cupertino.dart';
import 'package:pencilo/data/consts/const_import.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';

// class ProfileView extends StatelessWidget {
//   const ProfileView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CustomText(text: "Profile View"),
//     );
//   }
// }



class StudentProfilePage extends StatefulWidget {
  const StudentProfilePage({Key? key}) : super(key: key);

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = false;

  // Student data model
  final Map<String, dynamic> _studentInfo = {
    'name': 'Rahul Sharma',
    'class': '8',
    'section': 'A',
    'rollNo': '15',
    'admissionNo': 'A20230015',
    'email': 'rahul.sharma@school.edu',
    'phone': '+91 9876543210',
    'address': '123 School Lane, New Delhi',
    'dateOfBirth': '12 June 2009',
    'bloodGroup': 'O+',
    'parentName': 'Rajesh Sharma',
    'parentPhone': '+91 9876543211',
  };

  // Attendance data
  final Map<String, dynamic> _attendanceData = {
    'daysPresent': 20,
    'totalDays': 25,
    'percentage': 80,
    'history': [
      {'date': 'March 1', 'status': 'Present', 'isPresent': true},
      {'date': 'March 2', 'status': 'Present', 'isPresent': true},
      {'date': 'March 3', 'status': 'Absent', 'isPresent': false},
      {'date': 'March 4', 'status': 'Present', 'isPresent': true},
      {'date': 'March 5', 'status': 'Absent', 'isPresent': false},
      {'date': 'March 6', 'status': 'Present', 'isPresent': true},
      {'date': 'March 7', 'status': 'Present', 'isPresent': true},
    ]
  };

  // Subject marks data
  final List<Map<String, dynamic>> _subjectMarks = [
    {
      'subject': 'Mathematics',
      'theoryMarks': 85,
      'practicalMarks': 18,
      'totalMarks': 103,
      'maxMarks': 120,
      'grade': 'A+',
      'icon': Icons.calculate,
      'color': Colors.blue,
    },
    {
      'subject': 'Science',
      'theoryMarks': 76,
      'practicalMarks': 19,
      'totalMarks': 95,
      'maxMarks': 120,
      'grade': 'A',
      'icon': Icons.science,
      'color': Colors.green,
    },
    {
      'subject': 'English',
      'theoryMarks': 72,
      'practicalMarks': 16,
      'totalMarks': 88,
      'maxMarks': 100,
      'grade': 'A',
      'icon': Icons.book,
      'color': Colors.purple,
    },
    {
      'subject': 'Hindi',
      'theoryMarks': 68,
      'practicalMarks': 15,
      'totalMarks': 83,
      'maxMarks': 100,
      'grade': 'B+',
      'icon': Icons.translate,
      'color': Colors.orange,
    },
    {
      'subject': 'Social Studies',
      'theoryMarks': 74,
      'practicalMarks': 17,
      'totalMarks': 91,
      'maxMarks': 100,
      'grade': 'A',
      'icon': Icons.public,
      'color': Colors.red,
    },
  ];

  // Homework list
  final List<Map<String, dynamic>> _homeworkList = [
    {
      'subject': 'Mathematics',
      'task': 'Solve 10 algebra problems.',
      'dueDate': '10 March 2025',
      'isCompleted': true,
      'icon': Icons.calculate,
    },
    {
      'subject': 'Science',
      'task': 'Write a report on climate change.',
      'dueDate': '12 March 2025',
      'isCompleted': false,
      'icon': Icons.science,
    },
    {
      'subject': 'English',
      'task': 'Read chapter 3 and summarize.',
      'dueDate': '11 March 2025',
      'isCompleted': true,
      'icon': Icons.book,
    },
    {
      'subject': 'Hindi',
      'task': 'Write an essay on \'My Best Friend\'.',
      'dueDate': '13 March 2025',
      'isCompleted': false,
      'icon': Icons.translate,
    },
    {
      'subject': 'Social Studies',
      'task': 'Prepare a presentation on World War II.',
      'dueDate': '15 March 2025',
      'isCompleted': false,
      'icon': Icons.public,
    },
  ];

  // Calculated results
  Map<String, dynamic> get _results {
    int totalMarks =
    _subjectMarks.fold(0, (sum, item) => sum + (item['totalMarks'] as int));
    int maxMarks =
    _subjectMarks.fold(0, (sum, item) => sum + (item['maxMarks'] as int));
    double percentage = (totalMarks / maxMarks) * 100;

    String overallGrade;
    if (percentage >= 90) {
      overallGrade = 'A+';
    } else if (percentage >= 80) {
      overallGrade = 'A';
    } else if (percentage >= 70) {
      overallGrade = 'B+';
    } else if (percentage >= 60) {
      overallGrade = 'B';
    } else if (percentage >= 50) {
      overallGrade = 'C';
    } else if (percentage >= 40) {
      overallGrade = 'D';
    } else {
      overallGrade = 'F';
    }

    return {
      'totalMarks': totalMarks,
      'maxMarks': maxMarks,
      'percentage': percentage.toStringAsFixed(2),
      'grade': overallGrade,
    };
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Listen for tab changes to update UI
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Function to toggle theme
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // Function to generate and print PDF report card
  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('School Report Card',
                    textAlign: pw.TextAlign.center),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name: ${_studentInfo['name']}'),
                      pw.Text(
                          'Class: ${_studentInfo['class']} ${_studentInfo['section']}'),
                      pw.Text('Roll No: ${_studentInfo['rollNo']}'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Admission No: ${_studentInfo['admissionNo']}'),
                      pw.Text('Session: 2024-2025'),
                      pw.Text('Term: First Term'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Header row
                  pw.TableRow(
                    decoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Subject',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Theory',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Practical',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Total',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Max',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Grade',
                            style:
                            pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  // Subject rows
                  ..._subjectMarks.map((subject) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['subject']),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['theoryMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child:
                        pw.Text(subject['practicalMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['totalMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['maxMarks'].toString()),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(subject['grade']),
                      ),
                    ],
                  )),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Total Marks: ${_results['totalMarks']} / ${_results['maxMarks']}'),
                    pw.Text('Percentage: ${_results['percentage']}%'),
                    pw.Text('Overall Grade: ${_results['grade']}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        'Attendance: ${_attendanceData['daysPresent']} / ${_attendanceData['totalDays']} days (${_attendanceData['percentage']}%)'),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 100,
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Class Teacher'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 100,
                        height: 0.5,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text('Principal'),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set theme based on dark mode state
    final ThemeData theme = _isDarkMode
        ? ThemeData.dark().copyWith(
      primaryColor: Colors.indigo,
      colorScheme: const ColorScheme.dark(
        primary: Colors.indigo,
        secondary: Colors.indigoAccent,
      ),
    )
        : ThemeData.light().copyWith(
      primaryColor: Colors.indigo,
      colorScheme: const ColorScheme.light(
        primary: Colors.indigo,
        secondary: Colors.indigoAccent,
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220.0,
              floating: false,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: _toggleTheme,
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: _generatePDF,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_studentInfo['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _isDarkMode
                        ? Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.indigo, Colors.black54],
                        ),
                      ),
                    )
                        : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.indigo, Colors.indigoAccent],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 70,
                      child: Hero(
                        tag: 'profile-image',
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 38,
                            backgroundImage:
                            const AssetImage('assets/student_avatar.png'),
                            onBackgroundImageError: (_, __) {},
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.school, color: Colors.indigo),
                                const SizedBox(width: 8),
                                const Text(
                                  "Academic Details",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Chip(
                                  label: Text(
                                    "Class ${_studentInfo['class']} ${_studentInfo['section']}",
                                  ),
                                  backgroundColor: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                                icon: Icons.numbers,
                                title: "Roll No",
                                value: _studentInfo['rollNo']),
                            DetailRow(
                                icon: Icons.badge,
                                title: "Admission No",
                                value: _studentInfo['admissionNo']),
                            DetailRow(
                                icon: Icons.calendar_today,
                                title: "Date of Birth",
                                value: _studentInfo['dateOfBirth']),
                            DetailRow(
                                icon: Icons.bloodtype,
                                title: "Blood Group",
                                value: _studentInfo['bloodGroup']),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.contact_phone,
                                    color: Colors.indigo),
                                const SizedBox(width: 8),
                                const Text(
                                  "Contact Information",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DetailRow(
                                icon: Icons.email,
                                title: "Email",
                                value: _studentInfo['email']),
                            DetailRow(
                                icon: Icons.phone,
                                title: "Phone",
                                value: _studentInfo['phone']),
                            DetailRow(
                                icon: Icons.home,
                                title: "Address",
                                value: _studentInfo['address']),
                            DetailRow(
                                icon: Icons.person,
                                title: "Parent",
                                value: _studentInfo['parentName']),
                            DetailRow(
                                icon: Icons.phone_android,
                                title: "Parent Phone",
                                value: _studentInfo['parentPhone']),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor:
                  theme.colorScheme.onBackground.withOpacity(0.6),
                  indicatorColor: theme.colorScheme.primary,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(icon: Icon(Icons.assessment), text: "Marks"),
                    Tab(icon: Icon(Icons.calendar_today), text: "Attendance"),
                    Tab(icon: Icon(Icons.assignment), text: "Homework"),
                    Tab(icon: Icon(Icons.schedule), text: "Timetable"),
                  ],
                ),
                color: theme.scaffoldBackgroundColor,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Marks Tab
                    _buildMarksTab(),

                    // Attendance Tab
                    _buildAttendanceTab(),

                    // Homework Tab
                    _buildHomeworkTab(),

                    // Timetable Tab
                    _buildTimetableTab(),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: _tabController.index == 0
              ? FloatingActionButton.extended(
            key: const ValueKey<String>('generate_pdf'),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Download Report"),
            onPressed: _generatePDF,
          )
              : null,
        ),
      ),
    );
  }

  Widget _buildMarksTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Overall Performance",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getGradeColor(_results['grade']),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Grade: ${_results['grade']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: double.parse(_results['percentage']) / 100,
                      backgroundColor: Colors.grey[300],
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Percentage: ${_results['percentage']}%",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Total Marks: ${_results['totalMarks']} / ${_results['maxMarks']}",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Subject Breakdown",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _subjectMarks.length,
              itemBuilder: (context, index) {
                final subject = _subjectMarks[index];
                final percentage =
                    (subject['totalMarks'] / subject['maxMarks']) * 100;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                              subject['color'].withOpacity(0.2),
                              child: Icon(subject['icon'],
                                  color: subject['color']),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject['subject'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: percentage / 100,
                                    backgroundColor: Colors.grey[300],
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getGradeColor(subject['grade']),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                subject['grade'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMarkItem("Theory", subject['theoryMarks']),
                            _buildMarkItem(
                                "Practical", subject['practicalMarks']),
                            _buildMarkItem("Total", subject['totalMarks'],
                                isTotal: true),
                            _buildMarkItem("Max", subject['maxMarks']),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkItem(String label, int value, {bool isTotal = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Attendance Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAttendanceCircle(
                        "${_attendanceData['percentage']}%",
                        "Attendance",
                        _getAttendanceColor(_attendanceData['percentage']),
                      ),
                      _buildAttendanceCircle(
                        "${_attendanceData['daysPresent']}",
                        "Days Present",
                        Colors.green,
                      ),
                      _buildAttendanceCircle(
                        "${_attendanceData['totalDays'] - _attendanceData['daysPresent']}",
                        "Days Absent",
                        Colors.red,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _attendanceData['percentage'] / 100,
                    backgroundColor: Colors.grey[300],
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Total School Days: ${_attendanceData['totalDays']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Attendance History",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _attendanceData['history'].length,
              itemBuilder: (context, index) {
                final record = _attendanceData['history'][index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: record['isPresent']
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      child: Icon(
                        record['isPresent'] ? Icons.check : Icons.close,
                        color: record['isPresent'] ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(record['date']),
                    trailing: Text(
                      record['status'],
                      style: TextStyle(
                        color: record['isPresent'] ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCircle(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildHomeworkTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Homework Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildHomeworkSummaryItem(
                        _homeworkList.length.toString(),
                        "Total",
                        Colors.blue,
                        Icons.assignment,
                      ),
                      const SizedBox(width: 36),
                      _buildHomeworkSummaryItem(
                        _homeworkList
                            .where((hw) => hw['isCompleted'])
                            .length
                            .toString(),
                        "Completed",
                        Colors.green,
                        Icons.check_circle,
                      ),
                      const SizedBox(width: 36),
                      _buildHomeworkSummaryItem(
                        _homeworkList
                            .where((hw) => !hw['isCompleted'])
                            .length
                            .toString(),
                        "Pending",
                        Colors.orange,
                        Icons.pending_actions,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _homeworkList.length,
              itemBuilder: (context, index) {
                final homework = _homeworkList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: Colors.indigo.withOpacity(0.2),
                      child: Icon(homework['icon'], color: Colors.indigo),
                    ),
                    title: Text(
                      homework['subject'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(homework['task']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              "Due: ${homework['dueDate']}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Checkbox(
                      value: homework['isCompleted'],
                      onChanged: (value) {
                        setState(() {
                          homework['isCompleted'] = value;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkSummaryItem(
      String count, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildTimetableTab() {
    // Sample timetable data
    final List<Map<String, dynamic>> timetable = [
      {
        'day': 'Monday',
        'periods': [
          {
            'time': '8:00 - 9:00',
            'subject': 'Mathematics',
            'teacher': 'Mr. Gupta'
          },
          {
            'time': '9:00 - 10:00',
            'subject': 'Science',
            'teacher': 'Mrs. Sharma'
          },
          {
            'time': '10:15 - 11:15',
            'subject': 'English',
            'teacher': 'Mr. Kumar'
          },
          {
            'time': '11:15 - 12:15',
            'subject': 'Social Studies',
            'teacher': 'Mr. Singh'
          },
          {
            'time': '13:00 - 14:00',
            'subject': 'Hindi',
            'teacher': 'Mrs. Verma'
          },
          {
            'time': '14:00 - 15:00',
            'subject': 'Physical Education',
            'teacher': 'Mr. Yadav'
          },
        ]
      },
      {
        'day': 'Tuesday',
        'periods': [
          {
            'time': '8:00 - 9:00',
            'subject': 'Science',
            'teacher': 'Mrs. Sharma'
          },
          {
            'time': '9:00 - 10:00',
            'subject': 'Mathematics',
            'teacher': 'Mr. Gupta'
          },
          {
            'time': '10:15 - 11:15',
            'subject': 'Hindi',
            'teacher': 'Mrs. Verma'
          },
          {
            'time': '11:15 - 12:15',
            'subject': 'English',
            'teacher': 'Mr. Kumar'
          },
          {
            'time': '13:00 - 14:00',
            'subject': 'Computer Science',
            'teacher': 'Mr. Mehta'
          },
          {'time': '14:00 - 15:00', 'subject': 'Art', 'teacher': 'Mrs. Kapoor'},
        ]
      },
      {
        'day': 'Wednesday',
        'periods': [
          {'time': '8:00 - 9:00', 'subject': 'English', 'teacher': 'Mr. Kumar'},
          {'time': '9:00 - 10:00', 'subject': 'Hindi', 'teacher': 'Mrs. Verma'},
          {
            'time': '10:15 - 11:15',
            'subject': 'Mathematics',
            'teacher': 'Mr. Gupta'
          },
          {
            'time': '11:15 - 12:15',
            'subject': 'Science',
            'teacher': 'Mrs. Sharma'
          },
          {
            'time': '13:00 - 14:00',
            'subject': 'Social Studies',
            'teacher': 'Mr. Singh'
          },
          {'time': '14:00 - 15:00', 'subject': 'Music', 'teacher': 'Mrs. Roy'},
        ]
      },
      {
        'day': 'Thursday',
        'periods': [
          {
            'time': '8:00 - 9:00',
            'subject': 'Social Studies',
            'teacher': 'Mr. Singh'
          },
          {
            'time': '9:00 - 10:00',
            'subject': 'English',
            'teacher': 'Mr. Kumar'
          },
          {
            'time': '10:15 - 11:15',
            'subject': 'Science',
            'teacher': 'Mrs. Sharma'
          },
          {
            'time': '11:15 - 12:15',
            'subject': 'Hindi',
            'teacher': 'Mrs. Verma'
          },
          {
            'time': '13:00 - 14:00',
            'subject': 'Mathematics',
            'teacher': 'Mr. Gupta'
          },
          {
            'time': '14:00 - 15:00',
            'subject': 'Computer Science',
            'teacher': 'Mr. Mehta'
          },
        ]
      },
      {
        'day': 'Friday',
        'periods': [
          {'time': '8:00 - 9:00', 'subject': 'Hindi', 'teacher': 'Mrs. Verma'},
          {
            'time': '9:00 - 10:00',
            'subject': 'Social Studies',
            'teacher': 'Mr. Singh'
          },
          {
            'time': '10:15 - 11:15',
            'subject': 'Science',
            'teacher': 'Mrs. Sharma'
          },
          {
            'time': '11:15 - 12:15',
            'subject': 'Mathematics',
            'teacher': 'Mr. Gupta'
          },
          {
            'time': '13:00 - 14:00',
            'subject': 'English',
            'teacher': 'Mr. Kumar'
          },
          {
            'time': '14:00 - 15:00',
            'subject': 'Library',
            'teacher': 'Mrs. Joshi'
          },
        ]
      },
    ];

    return DefaultTabController(
      length: timetable.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: timetable.map((day) => Tab(text: day['day'])).toList(),
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
            Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: TabBarView(
              children: timetable.map((day) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: day['periods'].length,
                    itemBuilder: (context, index) {
                      final period = day['periods'][index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  period['time'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      period['subject'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      period['teacher'],
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground
                                            .withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.purple;
      case 'A':
        return Colors.blue;
      case 'B+':
        return Colors.green;
      case 'B':
        return Colors.teal;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.amber;
      default:
        return Colors.red;
    }
  }

  Color _getAttendanceColor(int percentage) {
    if (percentage >= 90) {
      return Colors.green;
    } else if (percentage >= 75) {
      return Colors.blue;
    } else if (percentage >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}

// Custom delegate for SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, {required this.color});

  final TabBar _tabBar;
  final Color color;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

// Widget for detail rows in cards
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailRow({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            "$title:",
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
