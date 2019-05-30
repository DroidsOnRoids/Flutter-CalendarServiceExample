import 'package:device_calendar/device_calendar.dart';

class GetEventsParams {
  const GetEventsParams({this.eventIds, this.startDate, this.endDate});

  final List<String> eventIds;
  final DateTime startDate;
  final DateTime endDate;

  RetrieveEventsParams get retrieveEventsParams => RetrieveEventsParams(
        eventIds: eventIds,
        startDate: startDate,
        endDate: endDate,
      );
}
