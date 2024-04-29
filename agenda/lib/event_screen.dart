import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agenda/event.dart';

class EventScreen extends StatefulWidget {
  final Event? event;

  EventScreen(this.event);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event?.title ?? '');
    _descriptionController = TextEditingController(text: widget.event?.description ?? '');
    _selectedTime = widget.event?.time ?? TimeOfDay.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveEvent(BuildContext context) {
    final String title = _titleController.text;
    final String description = _descriptionController.text;

    Navigator.pop(context, {'title': title, 'description': description, 'time': _selectedTime});
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? "Nuevo Evento" : "Editar Evento"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 189, 140, 207),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 205, 240, 208)!, Color.fromARGB(255, 215, 201, 220)!], // Cambiar los colores del fondo
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Título del evento",
                filled: true,
                fillColor: Color.fromARGB(255, 251, 255, 251), // Cambiar el color del campo de texto
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                filled: true,
                fillColor: Colors.white, // Cambiar el color del campo de texto
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            InkWell(
              onTap: () => _selectTime(context),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Hora del evento',
                  filled: true,
                  fillColor: Colors.white, // Cambiar el color del campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hora del evento:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_selectedTime.format(context)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _saveEvent(context),
              child: Text("Guardar"),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 0, 0, 0), 
                backgroundColor: Color.fromARGB(255, 132, 202, 172),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
