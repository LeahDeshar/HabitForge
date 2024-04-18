import 'package:flutter/material.dart';
import 'package:habittracker/models/app_settings.dart';
import 'package:habittracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;
  final List<Habit> currentHabits = [];

// Database initialization
  static Future<void> initialize() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      isar = await Isar.open(
        [HabitSchema, AppSettingsSchema],
        directory: dir.path,
        inspector: true,
      );
    } catch (e) {
      print('Failed to initialize database: $e');
    }
  }

  // Save first date of app start up (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // CRUD operations for habits
  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(() => isar.habits.put(newHabit));
    readHabit();
  }

  Future<void> readHabit() async {
    List<Habit> fechedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fechedHabits);
    notifyListeners();
  }

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          final today = DateTime.now();
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        } else {
          habit.completedDays.removeWhere((element) =>
              element.year == DateTime.now().year &&
              element.month == DateTime.now().month &&
              element.day == DateTime.now().day);
        }
        await isar.habits.put(habit);
      });
    }
    readHabit();
  }

  // update edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        await isar.habits.put(habit);
      });
    }
    readHabit();
  }

  // Delete habits
  Future<void> deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabit();
  }
}
// import 'package:flutter/material.dart';
// import 'package:habittracker/models/app_settings.dart';
// import 'package:habittracker/models/habit.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';

// class HabitDatabase extends ChangeNotifier {
//   static late Isar isar;

// // Initialize the database
//   static Future<void> initialize() async {
//     final dir = await getApplicationDocumentsDirectory();
//     isar =
//         await Isar.open([HabitSchema, AppSettingsSchema], directory: dir.path);
//   }

// // Save first date of launch
//   Future<void> saveFirstLaunchDate() async {
//     final existingSettings = await isar.appSettings.where().findFirst();
//     if (existingSettings == null) {
//       final settings = AppSettings()..firstLaunchDate = DateTime.now();
//       await isar.writeTxn(() => isar.appSettings.put(settings));
//     }
//   }

// // Get first date of launch
//   Future<DateTime?> getFirstLaunchDate() async {
//     final settings = await isar.appSettings.where().findFirst();
//     return settings?.firstLaunchDate;
//   }

// // C R U D  Operations

// // List of habits
//   final List<Habit> currentHabits = [];

// // add a new habit
//   Future<void> addHabit(String habitName) async {
//     // Create a new habit
//     final newHabit = Habit()..name = habitName;
//     // Add the habit to the database
//     await isar.writeTxn(() => isar.habits.put(newHabit));
//     // Read all habits from the database
//     readHabits();
//   }

//   Future<void> readHabits() async {
//     // Read all habits from the database
//     List<Habit> fetchedHabits = await isar.habits.where().findAll();
//     // Update the list of habits
//     currentHabits.clear();
//     // Add the fetched habits to the list of habits
//     currentHabits.addAll(fetchedHabits);
//     // Notify listeners
//     notifyListeners();
//   }

//   Future<void> updateHabitCompletion(int id, bool isCompleted) async {
//     // Get the habit with the given id
//     final habit = await isar.habits.get(id);
//     // If the habit exists
//     if (habit != null) {
//       // Update the habit
//       await isar.writeTxn(() async {
//         // If the habit is completed and not already in the list of completed days
//         if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
//           // Add the current date to the list of completed days
//           final today = DateTime.now();
//           habit.completedDays.add(DateTime(today.year, today.month, today.day));
//         } else {
//           // Remove the current date from the list of completed days
//           habit.completedDays.removeWhere((date) =>
//               date.year == DateTime.now().year &&
//               date.month == DateTime.now().month &&
//               date.day == DateTime.now().day);
//         }
//         // Update the habit in the database
//         await isar.habits.put(habit);
//       });
//       readHabits();
//     }
//   }

//   Future<void> updateHabitName(int id, String newName) async {
//     // Get the habit with the given id
//     final habit = await isar.habits.get(id);
//     // If the habit exists
//     if (habit != null) {
//       // Update the habit
//       await isar.writeTxn(() async {
//         habit.name = newName;
//         // Update the habit in the database
//         await isar.habits.put(habit);
//       });
//       readHabits();
//     }
//   }

//   Future<void> deleteHabit(int id) async {
//     await isar.writeTxn(() => isar.habits.delete(id));
//     readHabits();
//   }
// }
