import 'dart:async';

import 'package:async/async.dart';
import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/calendars/states/calendars_state.dart';

abstract class CalendarsPageBloc {
  static CalendarsPageBloc build() => _CalendarsPageBlocImpl(CalendarService.build());

  Stream<CalendarsState> get calendarsState;

  void loadCalendars();

  void dispose();
}

class _CalendarsPageBlocImpl implements CalendarsPageBloc {
  _CalendarsPageBlocImpl(this.calendarService);

  final CalendarService calendarService;

  final StreamController<CalendarsState> _calendarsController =
      StreamController<CalendarsState>.broadcast();

  @override
  Stream<CalendarsState> get calendarsState => _calendarsController.stream;

  @override
  void loadCalendars() {
    _calendarsController.add(CalendarsLoading());
    calendarService.calendars.then(
      (Result<List<DeviceCalendar>> result) {
        if (result.isError) {
          _calendarsController
              .add(CalendarsError(result.asError.error.toString()));
        } else if (result.isValue && result.asValue.value != null) {
          _calendarsController.add(CalendarsLoaded(result.asValue.value));
        } else {
          _calendarsController.add(CalendarsEmpty());
        }
      },
    );
  }

  @override
  void dispose() {
    _calendarsController.close();
  }
}
