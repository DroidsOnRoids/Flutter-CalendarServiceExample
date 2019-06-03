import 'package:async/async.dart';
import 'package:device_calendar/device_calendar.dart' as c;
import 'package:device_calendar_example/calendar_service/models/device_calendar.dart';
import 'package:device_calendar_example/calendar_service/models/device_event.dart';
import 'package:device_calendar_example/calendar_service/models/get_events_params.dart';

export 'models/device_calendar.dart';
export 'models/device_event.dart';
export 'models/event_attendee.dart';
export 'models/get_events_params.dart';

abstract class CalendarService {
  Future<Result<List<DeviceCalendar>>> get calendars;

  Future<Result<List<CalendarEvent>>> getEventsFromCalendar(
    String calendarId,
    GetEventsParams getEventsParams,
  );

  Future<Result<String>> createOrUpdateEvent(c.Event event);

  Future<Result<bool>> deleteEvent(String calendarId, String eventId);

  static CalendarService build() => _CalendarServiceImpl();
}

class _CalendarServiceImpl implements CalendarService {
  final c.DeviceCalendarPlugin _deviceCalendarPlugin = c.DeviceCalendarPlugin();

  @override
  Future<Result<List<DeviceCalendar>>> get calendars async {
    try {
      await _getPermissionsOrThrow();
    } on Exception catch (e) {
      return Result<List<DeviceCalendar>>.error(e);
    }

    return _callFuture(
      _deviceCalendarPlugin.retrieveCalendars(),
      mappingFunction: (List<c.Calendar> calendars) {
        return calendars.map((c.Calendar event) {
          return DeviceCalendar.from(event);
        }).toList();
      },
    );
  }

  @override
  Future<Result<List<CalendarEvent>>> getEventsFromCalendar(
      String calendarId, GetEventsParams getEventsParams) async {
    assert(getEventsParams != null);

    try {
      await _getPermissionsOrThrow();
    } on Exception catch (e) {
      return Result<List<CalendarEvent>>.error(e);
    }

    return _callFuture(
      _deviceCalendarPlugin.retrieveEvents(
          calendarId, getEventsParams.retrieveEventsParams),
      mappingFunction: (List<c.Event> events) {
        return events.map((c.Event event) {
          return CalendarEvent.from(event);
        }).toList();
      },
    );
  }

  @override
  Future<Result<String>> createOrUpdateEvent(c.Event event) async {
    try {
      await _getPermissionsOrThrow();
    } on Exception catch (e) {
      return Result<String>.error(e);
    }

    return _callFuture(_deviceCalendarPlugin.createOrUpdateEvent(event));
  }

  @override
  Future<Result<bool>> deleteEvent(String calendarId, String eventId) async {
    try {
      await _getPermissionsOrThrow();
    } on Exception catch (e) {
      return Result<bool>.error(e);
    }

    return _callFuture(_deviceCalendarPlugin.deleteEvent(calendarId, eventId));
  }

  /// Private methods

  Future<Result<OutputType>> _callFuture<InputType, OutputType>(
      Future<c.Result<InputType>> futureMethod,
      {OutputType Function(InputType) mappingFunction}) async {
    if (OutputType != InputType) {
      assert(mappingFunction != null);
    }

    final c.Result<InputType> result = await futureMethod;

    if (result.isSuccess && result.data != null) {
      final OutputType output = (InputType == OutputType)
          ? result.data
          : mappingFunction(result.data);

      return Result<OutputType>.value(output);
    } else {
      return Result<OutputType>.error(result.errorMessages.join('\n'));
    }
  }

  Future<void> _getPermissionsOrThrow() async {
    final bool permissionGranted = await _permissionsGranted;

    if (!permissionGranted) {
      final bool requestedPermissionsGranted = await _requestPermissions;

      if (!requestedPermissionsGranted) {
        throw Exception('Permissions declined');
      }
    }
  }

  Future<bool> get _permissionsGranted async {
    final c.Result<bool> permissionsGranted =
        await _deviceCalendarPlugin.hasPermissions();
    return permissionsGranted.isSuccess && permissionsGranted.data;
  }

  Future<bool> get _requestPermissions async {
    final c.Result<bool> permissionsGranted =
        await _deviceCalendarPlugin.requestPermissions();
    return permissionsGranted.isSuccess && permissionsGranted.data;
  }
}
