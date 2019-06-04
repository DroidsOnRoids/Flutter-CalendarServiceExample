import 'package:flutter/material.dart';

class LocationView extends StatelessWidget {
  const LocationView({Key key, this.location}) : super(key: key);

  final String location;

  @override
  Widget build(BuildContext context) {
    if (location != null && location.isNotEmpty) {
      return Row(
        children: <Widget>[
          const Icon(
            Icons.location_on,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              location,
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
}
