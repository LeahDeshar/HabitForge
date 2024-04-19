import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const MyHabitTile(
      {super.key,
      required this.isCompleted,
      required this.text,
      required this.onChanged,
      required this.deleteHabit,
      required this.editHabit});

  // bool _isCompleted = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(motion: const StretchMotion(), children: [
          SlidableAction(
            backgroundColor: Colors.grey.shade900,
            onPressed: editHabit,
            icon: Icons.settings,
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            backgroundColor: Colors.red,
            onPressed: deleteHabit,
            icon: Icons.delete,
            borderRadius: BorderRadius.circular(8),
          )
        ]),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompleted);
            }
            // setState(() {
            //   _isCompleted = !_isCompleted;
            // });
            // widget.onChanged?.call(_isCompleted);
          },
          child: Container(
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: ListTile(
                  title: Text(text,
                      style: TextStyle(
                          color: isCompleted
                              ? Colors.white
                              : Theme.of(context).colorScheme.inversePrimary)),
                  leading: Checkbox(
                      activeColor: Colors.green,
                      value: isCompleted,
                      onChanged: onChanged))),
        ),
      ),
    );
  }
}
