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

    final c.Result<List<c.Calendar>> calendarsResult =
        await _deviceCalendarPlugin.retrieveCalendars();

    return _mapResult(
      calendarsResult,
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

    final c.Result<List<c.Event>> eventsResult = await _deviceCalendarPlugin
        .retrieveEvents(calendarId, getEventsParams.retrieveEventsParams);

    return _mapResult(
      eventsResult,
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

    final c.Result<String> modificationResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(event);

    return _mapResult(modificationResult);
  }

  @override
  Future<Result<bool>> deleteEvent(String calendarId, String eventId) async {
    try {
      await _getPermissionsOrThrow();
    } on Exception catch (e) {
      return Result<bool>.error(e);
    }

    final c.Result<bool> deletionResult =
        await _deviceCalendarPlugin.deleteEvent(calendarId, eventId);

    return _mapResult(deletionResult);
  }

  /// Private methods

  Future<Result<OutputType>> _mapResult<InputType, OutputType>(
      c.Result<InputType> result,
      {OutputType Function(InputType) mappingFunction}) async {
    if (OutputType != InputType) {
      assert(mappingFunction != null);
    }
    
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
