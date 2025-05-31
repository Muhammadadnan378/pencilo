import '../data/consts/const_import.dart';
import '../data/consts/images.dart';

class EventsController extends GetxController{
  RxInt selectedIndex = 40.obs;
  RxString selectedEventType = "".obs;
  final List<IconData> icon = [
    Icons.directions_run,             // For Run
    Icons.sports_basketball,          // For Basketball
    Icons.sports_tennis,              // For Tennis (Could be used for Badminton too)
    Icons.sports_football,            // For Football
    Icons.sports_cricket,             // For Cricket
    Icons.sports_baseball,            // For Baseball
    Icons.sports_volleyball,          // For Volleyball
    Icons.sports_handball,            // For Handball (Added for example)
    Icons.sports_kabaddi,             // For Kabaddi (Added for example)
    Icons.sports_rugby,               // For Rugby (Added for example)
    Icons.videogame_asset,            // For PUBG (Added for example)
    Icons.videogame_asset_outlined,   // For BGMI (Added for example)
    Icons.sports_hockey,              // For Hockey (Added for example)
    Icons.sports_tennis,              // Placeholder for Badminton
    Icons.sports_basketball,          // Placeholder for Table Tennis
  ];


  final List<String> sportsNames = [
    "Run",             // Updated names for sports
    "Basketball",
    "Tennis",
    "Football",
    "Cricket",
    "Baseball",
    "Volleyball",
    "Handball",        // Added
    "Kabaddi",         // Added
    "Rugby",           // Added
    "PUBG",            // Added
    "BGMI",            // Added
    "Hockey",          // Added
    "Badminton",       // Added
    "Table Tennis",    // Added
  ];

  Map<String, String> eventImages = {
    'Cricket': Cricket,
    'Football': Football,
    'Basketball': BasketBall,
    'Baseball': BasketBall, // Or replace with actual if available
    'Badminton': Badminton,
    'Table Tennis': TableTennis,
    'Tennis': Tennis,
    'Hockey': Hockey,
    'Volleyball': Volleyball,
    'Kabaddi': Kabaddi,
    'KhoKho': KhoKho,
    'Dance': Dance,
    'Drawing': Drawing,
    'Reels': Reels,
    'Singing': Singing,
    'PUBG': PUBG,
    'FreeFire': FreeFire,
    'BGMI': PUBG, // Use a different image if you have
    'Run': Run,
  };

}