import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/calendars/calendars_page_bloc.dart';
import 'package:device_calendar_example/pages/calendars/states/calendars_state.dart';
import 'package:device_calendar_example/pages/events/events_page.dart';
import 'package:flutter/material.dart';

class CalendarsPage extends StatefulWidget {
  CalendarsPage({Key key, this.title}) : super(key: key);

  final String title;
  final CalendarsPageBloc _mainPageBloc = CalendarsPageBloc.build();

  @override
  _CalendarsPageState createState() => _CalendarsPageState();
}

class _CalendarsPageState extends State<CalendarsPage> {
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
          widget._mainPageBloc.loadCalendars();
        },
        tooltip: 'Download',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildContent() {
    return StreamBuilder<CalendarsState>(
      initialData: CalendarsEmpty(),
      stream: widget._mainPageBloc.calendarsState,
      builder: (BuildContext context, AsyncSnapshot<CalendarsState> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final CalendarsState calendarsState = snapshot.data;
        print('State: $calendarsState');
        if (calendarsState is CalendarsLoading) {
          return const CircularProgressIndicator();
        }

        if (calendarsState is CalendarsEmpty) {
          return const Text('Load data to see calendars');
        }

        if (calendarsState is CalendarsError) {
          return Text(calendarsState.errorMessage);
        }

        if (calendarsState is CalendarsLoaded) {
          return _createCalendarsList(calendarsState.deviceCalendars);
        }
      },
    );
  }

  Widget _createCalendarsList(List<DeviceCalendar> calendars) {
    return Expanded(
      child: ListView.builder(
        itemCount: calendars.length,
        itemBuilder: (BuildContext context, int index) {
          final DeviceCalendar calendar = calendars[index];
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Card(
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Id: ${calendar.id}\nName: ${calendar.name}\nIsReadOnly: ${calendar.isReadOnly}',
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<EventsPage>(
                      builder: (BuildContext context) =>
                          EventsPage('Events', calendar.id),
                    ),
                  );
                },
              ),
            ),
          );
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
