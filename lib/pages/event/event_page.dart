import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/calendars/states/calendars_state.dart';
import 'package:device_calendar_example/pages/event/event_page_bloc.dart';
import 'package:device_calendar_example/pages/event/states/event_state.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  EventPage(this.calendarId, this.eventId, {Key key, this.title})
      : _eventPageBloc = EventPageBloc.build(calendarId, eventId),
        super(key: key);

  final String title;
  final String calendarId;
  final String eventId;
  final EventPageBloc _eventPageBloc;

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(child: _buildContent()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget._eventPageBloc.loadEvent();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<EventState>(
      initialData: EventEmpty(),
      stream: widget._eventPageBloc.eventState,
      builder: (BuildContext context, AsyncSnapshot<EventState> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final EventState eventState = snapshot.data;
        print('State: $eventState');
        if (eventState is CalendarsLoading) {
          return const CircularProgressIndicator();
        }

        if (eventState is EventEmpty) {
          return const Text('Load data to see calendars');
        }

        if (eventState is EventError) {
          return Text(eventState.errorMessage);
        }

        if (eventState is EventLoaded) {
          return _createEventContent(eventState.calendarEvent);
        }
      },
    );
  }

  Widget _createEventContent(CalendarEvent calendars) {
    return Expanded();
  }

  @override
  void dispose() {
    print('Main Page Dispose');
    widget._eventPageBloc.dispose();
    super.dispose();
  }
}
