import 'dart:async';

import 'package:async/async.dart';
import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/event/states/event_state.dart';

abstract class EventPageBloc {
  static EventPageBloc build(String calendarId, String eventId) =>
      _EventPageBlocImpl(
        CalendarService.build(),
        calendarId,
        eventId,
      );

  Stream<EventState> get eventState;

  void loadEvent();

  void dispose();
}

class _EventPageBlocImpl implements EventPageBloc {
  _EventPageBlocImpl(this.calendarService, this.calendarId, this.eventId);

  final String calendarId;
  final String eventId;
  final CalendarService calendarService;

  final StreamController<EventState> _eventController =
      StreamController<EventState>.broadcast();

  @override
  Stream<EventState> get eventState => _eventController.stream;

  @override
  void loadEvent() {
    _eventController.add(EventLoading());
    calendarService
        .getEventsFromCalendar(
            calendarId, GetEventsParams(eventIds: <String>[eventId]))
        .then(
      (Result<List<CalendarEvent>> result) {
        if (result.isError) {
          _eventController.add(EventError(result.asError.error.toString()));
        } else if (result.isValue && result.asValue.value != null) {
          _eventController.add(EventLoaded(result.asValue.value.first));
        } else {
          _eventController.add(EventEmpty());
        }
      },
    );
  }

  @override
  void dispose() {
    _eventController.close();
  }
}
