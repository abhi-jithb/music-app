// lib/pages/alarm_page.dart
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isAM = true;

  void _selectTime(TimeOfDay picked) {
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _isAM = _selectedTime.period == DayPeriod.am;
      });
    }
  }

  Future<void> _selectTimeDialog() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ) ?? _selectedTime;

    _selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Alarm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Alarm Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${_selectedTime.hour}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_isAM ? 'AM' : 'PM'}',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _selectTimeDialog,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save the alarm setting logic
                Navigator.pop(context);
              },
              child: Text('Set Alarm'),
            ),
          ],
        ),
      ),
    );
  }
}
