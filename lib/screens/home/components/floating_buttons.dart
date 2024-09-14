import 'package:flutter/material.dart';
import 'package:daylyse/screens/note_screen.dart';
import 'package:daylyse/screens/home/annual_calendar_screen.dart';
import 'package:daylyse/screens/settings/settings_screen.dart';

class FloatingButtons extends StatelessWidget {
  final Map<DateTime, List<Map<String, dynamic>>> notes;
  final VoidCallback onAddNote;

  const FloatingButtons({
    required this.notes,
    required this.onAddNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 128.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'calendar',
            mini: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnnualCalendarScreen(notes: notes)),
              );
            },
            backgroundColor: Colors.grey.withOpacity(0.6),
            elevation: 0,
            shape: CircleBorder(),
            child: Icon(Icons.calendar_today, color: Colors.white, size: 24),
          ),
          FloatingActionButton(
            heroTag: 'addNote',
            onPressed: onAddNote,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 2,
            shape: CircleBorder(),
            child: Icon(Icons.add, color: Colors.white, size: 32),
          ),
          FloatingActionButton(
            heroTag: 'profile',
            mini: true,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
            backgroundColor: Colors.grey.withOpacity(0.6),
            elevation: 0,
            shape: CircleBorder(),
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
