import 'package:device_calendar/device_calendar.dart';

class EventAttendee {
  String name;

  EventAttendee(this.name);

  factory EventAttendee.from(Attendee attendee) => EventAttendee(attendee.name);
}
