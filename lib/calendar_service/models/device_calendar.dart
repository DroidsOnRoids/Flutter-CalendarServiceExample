import 'package:device_calendar/device_calendar.dart';

class DeviceCalendar {
  DeviceCalendar({this.id, this.name, this.isReadOnly});

  factory DeviceCalendar.from(Calendar calendar) => DeviceCalendar(
        id: calendar.id,
        name: calendar.name,
        isReadOnly: calendar.isReadOnly,
      );

  String id;
  String name;
  bool isReadOnly;
}
