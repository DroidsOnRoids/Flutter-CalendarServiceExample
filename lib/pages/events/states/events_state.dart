import 'package:device_calendar_example/calendar_service/calendar_service.dart';

abstract class EventsState {}

class EventsEmpty extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  EventsLoaded(this.calendarEvents);

  final List<CalendarEvent> calendarEvents;
}

class EventsError extends EventsState {
  EventsError(this.errorMessage);

  final String errorMessage;
}
