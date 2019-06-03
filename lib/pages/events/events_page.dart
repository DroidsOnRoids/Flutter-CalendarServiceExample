import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/events/events_page_bloc.dart';
import 'package:device_calendar_example/pages/events/list_item/event_list_item.dart';
import 'package:device_calendar_example/pages/events/states/events_state.dart';
import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  EventsPage(this.title, this.calendarId, {Key key})
      : _mainPageBloc = EventsPageBloc.build(calendarId),
        super(key: key);

  final String title;
  final String calendarId;
  final EventsPageBloc _mainPageBloc;

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    widget._mainPageBloc.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildContent(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget._mainPageBloc.loadEvents();
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<EventsState>(
      initialData: EventsEmpty(),
      stream: widget._mainPageBloc.eventsState,
      builder: (BuildContext context, AsyncSnapshot<EventsState> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final EventsState eventsState = snapshot.data;
        print('State: $eventsState');
        if (eventsState is EventsLoading) {
          return const CircularProgressIndicator();
        }

        if (eventsState is EventsEmpty) {
          return const Text('Load data to see calendars');
        }

        if (eventsState is EventsError) {
          return Text(eventsState.errorMessage);
        }

        if (eventsState is EventsLoaded) {
          return _createEventsList(eventsState.calendarEvents);
        }
      },
    );
  }

  Widget _createEventsList(List<CalendarEvent> events) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final CalendarEvent event = events[index];
          return EventListItem(event: event);
        },
      ),
    );
  }

  @override
  void dispose() {
    print('Main Page Dispose');
    widget._mainPageBloc.dispose();
    super.dispose();
  }
}
