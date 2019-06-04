import 'package:device_calendar_example/pages/calendars/calendars_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarsPage(title: 'Calendars List'),
    );
  }
}
