import 'package:device_calendar_example/calendar_service/calendar_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  const EventListItem({Key key, this.event}) : super(key: key);

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.deepPurple,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          splashColor: Colors.green,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  event.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                _buildLocation(event.location),
                const SizedBox(height: 16),
                _buildDate(event.start, event.end, event.allDay),
                const SizedBox(height: 16),
                _buildAttendees(event.attendees),
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildLocation(String location) {
    if (event.location != null && event.location.isNotEmpty) {
      return Row(
        children: <Widget>[
          const Icon(
            Icons.location_on,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              event.location,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildDate(DateTime start, DateTime end, bool allDay) {
    if (allDay) {
      return Row(
        children: <Widget>[
          const Icon(Icons.calendar_today),
          const SizedBox(width: 8),
          Text('${DateFormat('dd.MM.yyyy').format(start)} - All day')
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          const Icon(
            Icons.date_range,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'From: ${DateFormat('dd.MM.yyyy, HH:mm').format(start)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'To: ${DateFormat('dd.MM.yyyy, HH:mm').format(end)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildAttendees(List<EventAttendee> attendees) {
    final List<Widget> attendeesView =
        attendees.map(_buildAttendeeView).toList();
    return Column(
      children: attendeesView,
    );
  }

  Widget _buildAttendeeView(EventAttendee attendee) {
    if (attendee.name.isEmpty) {
      return Container();
    }

    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
      ),
      title: Text(attendee.name),
    );
  }
}
