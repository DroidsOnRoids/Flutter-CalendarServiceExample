import 'package:device_calendar_example/calendar_service/calendar_service.dart';

abstract class EventState {}

class EventEmpty extends EventState {}

class EventLoading extends EventState {}

class EventLoaded extends EventState {
  EventLoaded(this.calendarEvent);

  final CalendarEvent calendarEvent;
}

class EventError extends EventState {
  EventError(this.errorMessage);

  final String errorMessage;
}
