import '../../../data/consts/const_import.dart';

class ProfileHomeWorkView extends StatelessWidget {
  ProfileHomeWorkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
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
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _homeworkList.length,
                physics: NeverScrollableScrollPhysics(),
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
                        backgroundColor: Colors.indigo.withValues(alpha: 0.5),
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
                          homework['isCompleted'] = value;
                          // setState(() {
                          // });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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


  Widget _buildHomeworkSummaryItem(
      String count, String label, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.5),
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
}