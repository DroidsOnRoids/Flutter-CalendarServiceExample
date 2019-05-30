import 'package:device_calendar/device_calendar.dart';
import 'package:device_calendar_example/calendar_service/models/event_attendee.dart';

class DeviceEvent {

  DeviceEvent(
      this.calendarId, {
        this.eventId,
        this.title,
        this.start,
        this.end,
        this.description,
        this.allDay,
        this.location,
        this.attendees,
      });

  factory DeviceEvent.from(Event event) => DeviceEvent(
    event.calendarId,
    eventId: event.eventId,
    title: event.title,
    description: event.description,
    start: event.start,
    end: event.end,
    allDay: event.allDay,
    location: event.location,
    attendees: event.attendees.map((Attendee attendee) {
      return EventAttendee.from(attendee);
    }),
  );

  String eventId;
  String calendarId;
  String title;
  String description;
  DateTime start;
  DateTime end;
  bool allDay;
  String location;
  List<EventAttendee> attendees;

}
