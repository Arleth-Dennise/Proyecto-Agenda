import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:agenda/event.dart';
import 'package:agenda/event_screen.dart';
import 'package:agenda/login_screen.dart';

class Calendar extends StatefulWidget {
  final User user;

  const Calendar({Key? key, required this.user}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with TickerProviderStateMixin {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    loadEventsFromFirestore();
    super.initState();
  }

  Future<void> loadEventsFromFirestore() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    final userData = await userDoc.get();
    if (userData.exists) {
      final eventsData = userData.data()?['events'] ?? {};
      setState(() {
        selectedEvents = Map.fromIterable(eventsData.keys,
            key: (key) => DateTime.parse(key),
            value: (key) => (eventsData[key] as List<dynamic>)
                .map((eventJson) => Event.fromJson(eventJson as Map<String, dynamic>))
                .toList());
      });
    }
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _addEvent(DateTime date, String title, String description, TimeOfDay time) {
    String defaultTitle = title.isEmpty ? 'Titulo' : title;
    String defaultDescription = description.isEmpty ? 'Descripción del evento' : description;

    setState(() {
      selectedEvents.update(
        date,
        (existingEvents) => [
          ...existingEvents,
          Event(title: defaultTitle, description: defaultDescription, time: time)
        ],
        ifAbsent: () => [Event(title: defaultTitle, description: defaultDescription, time: time)],
      );
    });
    saveEventsToFirestore();
  }

  void _editEvent(DateTime date, int index, String title, String description, TimeOfDay time) {
    setState(() {
      selectedEvents[date]![index] = Event(title: title, description: description, time: time);
    });
    saveEventsToFirestore();
  }

  void _deleteEvent(DateTime date, int index) {
    setState(() {
      selectedEvents[date]!.removeAt(index);
    });
    saveEventsToFirestore();
  }

  Future<void> saveEventsToFirestore() async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(widget.user.uid);
    final eventData = selectedEvents.map((key, value) => MapEntry(
          key.toString(),
          value.map((event) => event.toJson()).toList(),
        ));
    await userDoc.set({'events': eventData}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Agenda"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 189, 140, 207),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _signOut(context),
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2060),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: _getEventsfromDay,
            calendarStyle: CalendarStyle(
              isTodayHighlighted: true,
              selectedDecoration: BoxDecoration(
                color: Color.fromARGB(255, 132, 202, 172),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 132, 202, 172),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Color.fromARGB(255, 132, 202, 172),
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: const Color.fromARGB(255, 215, 201, 220),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _getEventsfromDay(selectedDay).length,
                itemBuilder: (context, index) {
                  Event event = _getEventsfromDay(selectedDay)[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Editar o eliminar evento"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EventScreen(event)),
                                    ).then((value) {
                                      if (value != null && value is Map) {
                                        String title = value['title'];
                                        String description = value['description'];
                                        TimeOfDay time = value['time'];
                                       _editEvent(selectedDay, index, title, description, time);
                                      }
                                    });
                                  },
                                  child: Text("Editar"),
                                style: TextButton.styleFrom(
                                    foregroundColor: const Color.fromARGB(255, 28, 148, 32),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteEvent(selectedDay, index);
                                  },
                                  child: Text("Eliminar"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(event.description),
                            ],
                          ),
                          Text(
                            '${event.time.hour}:${event.time.minute}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventScreen(null)),
          ).then((value) {
            if (value != null && value is Map) {
              String title = value['title'];
              String description = value['description'];
              TimeOfDay time = value['time'];
              _addEvent(selectedDay, title, description, time);
            }
          });
        },
        label: Text("Añadir"),
        icon: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 132, 202, 172),
        foregroundColor: Colors.black,
      ),
    );
  }

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}