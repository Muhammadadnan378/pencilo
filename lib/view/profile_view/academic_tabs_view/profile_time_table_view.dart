import '../../../data/consts/const_import.dart';

class ProfileTimeTableView extends StatelessWidget {
  ProfileTimeTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: DefaultTabController(
        length: timetable.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: timetable.map((day) => Tab(text: day['day'])).toList(),
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
            Expanded( // ✅ This gives proper height to the tab content area
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
                                        .withValues(alpha: 0.5),
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
                                              .onSurface
                                              .withValues(alpha: 0.5),
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
      ),
    );
  }

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
}
