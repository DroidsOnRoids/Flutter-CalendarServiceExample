import 'dart:async';

import 'package:async/async.dart';
import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/events/states/events_state.dart';

abstract class EventsPageBloc {
  static EventsPageBloc build(String calendarId) =>
      _MainPageBlocImpl(calendarId, CalendarService.build());

  Stream<EventsState> get eventsState;

  void loadEvents();

  void dispose();
}

class _MainPageBlocImpl implements EventsPageBloc {
  _MainPageBlocImpl(this.calendarId, this.calendarService);

  final String calendarId;
  final CalendarService calendarService;

  final StreamController<EventsState> _eventsController =
      StreamController<EventsState>.broadcast();

  @override
  Stream<EventsState> get eventsState => _eventsController.stream;

  @override
  void loadEvents() {
    _eventsController.add(EventsLoading());
    final GetEventsParams params = GetEventsParams(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 365)),
    );
    calendarService.getEventsFromCalendar(calendarId, params).then(
      (Result<List<CalendarEvent>> result) {
        if (result.isError) {
          _eventsController.add(EventsError(result.asError.error.toString()));
        } else if (result.isValue && result.asValue.value != null) {
          final List<CalendarEvent> events = result.asValue.value
            ..sort((CalendarEvent firstEvent, CalendarEvent secondEvent) =>
                firstEvent.start.compareTo(secondEvent.start));
          _eventsController.add(EventsLoaded(events));
        } else {
          _eventsController.add(EventsEmpty());
        }
      },
    );
  }

  @override
  void dispose() {
    _eventsController.close();
  }
}
