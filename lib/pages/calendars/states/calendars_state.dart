import 'package:device_calendar_example/calendar_service/calendar_service.dart';

abstract class CalendarsState {}

class CalendarsEmpty extends CalendarsState {}

class CalendarsLoading extends CalendarsState {}

class CalendarsLoaded extends CalendarsState {
  CalendarsLoaded(this.deviceCalendars);

  final List<DeviceCalendar> deviceCalendars;
}

class CalendarsError extends CalendarsState {
  CalendarsError(this.errorMessage);

  final String errorMessage;
}
