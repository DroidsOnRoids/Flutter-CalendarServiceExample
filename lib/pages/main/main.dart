import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:device_calendar_example/pages/main/main_page_bloc.dart';
import 'package:device_calendar_example/pages/main/states/calendars_state.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calendars List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final MainPageBloc _mainPageBloc = MainPageBloc.build();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  print('selected: $index');
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
