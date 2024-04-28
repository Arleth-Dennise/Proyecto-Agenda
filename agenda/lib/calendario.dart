import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'event.dart';
import 'event_screen.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State with TickerProviderStateMixin {
  late Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
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
    setState(() {
      selectedEvents.update(
        date,
        (existingEvents) => [
          ...existingEvents,
          Event(title: title, description: description, time: time)
        ],
        ifAbsent: () => [Event(title: title, description: description, time: time)],
      );
    });
  }

  void _editEvent(DateTime date, int index, String title, String description, TimeOfDay time) {
    setState(() {
      selectedEvents[date]![index] = Event(title: title, description: description, time: time);
    });
  }

  void _deleteEvent(DateTime date, int index) {
    setState(() {
      selectedEvents[date]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 189, 140, 207),
        foregroundColor: Colors.white,
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
              print(focusedDay);
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
                                    foregroundColor: const Color.fromARGB(255, 28, 148, 32), // Color del texto del botón
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteEvent(selectedDay, index);
                                  },
                                  child: Text("Eliminar"),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red, // Color del texto del botón
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
                        color: Colors.white, // Color de fondo del contenedor de cada evento
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
        backgroundColor: const Color.fromARGB(255, 132, 202, 172), // Color de fondo del botón flotante
        foregroundColor: Colors.black, // Color del icono y del texto del botón flotante
      ),
    );
  }
}
