import 'package:flutter/cupertino.dart';
import 'package:vat_calculator/client/vatservice/model/event_model.dart';

class EventManagerScreen extends StatefulWidget {
  const EventManagerScreen({Key key, this.event}) : super(key: key);

  final EventModel event;

  @override
  _EventManagerScreenState createState() => _EventManagerScreenState();
}

class _EventManagerScreenState extends State<EventManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
