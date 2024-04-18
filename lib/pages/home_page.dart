import 'package:flutter/material.dart';
import 'package:habittracker/components/my_drawer.dart';
// import 'package:habittracker/database/habit_database.dart';
// import 'package:habittracker/models/habit.dart';
// import 'package:habittracker/utli/habit_util.dart';
// import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void initState() {
  //   Provider.of<HabitDatabase>(context, listen: false).readHabit();
  //   super.initState();
  // }

  final TextEditingController textController = TextEditingController();
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'Create a new habit',
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () {
                    // String newHabitName = textController.text;
                    // context.read<HabitDatabase>().addHabit(newHabitName);
                    // Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text('Save'),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      // body: _buildHabitList(),
    );
  }

  // Widget _buildHabitList() {
  //   final habitDatbase = context.watch<HabitDatabase>();
  //   List<Habit> currentHabits = habitDatbase.currentHabits;
  //   return ListView.builder(
  //     itemCount: currentHabits.length,
  //     itemBuilder: (context, index) {
  //       final habit = currentHabits[index];
  //       bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
  //       return ListTile(
  //         title: Text(habit.name),
  //       );
  //     },
  //   );
  // }
}
