import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import '../../models/evento_calendario_model.dart';
import '../../services/firestore.dart';

class AddEventPage extends StatefulWidget {
  final EventModel note;

  const AddEventPage({Key key, this.note}) : super(key: key);

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _titulo;
  TextEditingController _descricao;
  TextEditingController _local;
  TextEditingController _horario;
  String _time = "";
  DateTime _data;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _titulo = TextEditingController(
        text: widget.note != null ? widget.note.titulo : "");
    _descricao = TextEditingController(
        text: widget.note != null ? widget.note.descricao : "");
    _local = TextEditingController(
        text: widget.note != null ? widget.note.local : "");
    _horario = TextEditingController(
        text: widget.note != null ? widget.note.horario : "");
    _data = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? "Editar Evento" : "Adicionar Evento"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _titulo,
                  maxLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (text) => text.isEmpty ? 'Título inválido' : null,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _descricao,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    prefixIcon: Icon(Icons.description),
                  ),
                  validator: (text) =>
                      text.isEmpty ? 'Descrição inválida' : null,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _local,
                  minLines: 1,
                  decoration: InputDecoration(
                    labelText: 'Local',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  validator: (text) => text.isEmpty ? 'Local inválido' : null,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.access_time),
                    labelText: "Horário",
                    hintText: _horario.text,
                  ),
                  controller: _horario,
                  onTap: () {
                    {
                      _selectTime(context);
                    }
                  },
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Data:"),
                subtitle: Text("${_data.day} / ${_data.month} / ${_data.year}"),
                onTap: () async {
                  DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: _data,
                      firstDate: DateTime(_data.year - 5),
                      lastDate: DateTime(_data.year + 5));
                  if (picked != null) {
                    setState(() {
                      _data = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                          child: Text(
                            "Adicionar",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          color: Colors.blueAccent,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                processing = true;
                              });
                              if (widget.note != null) {
                                await eventDBS.updateItem(EventModel(
                                    id: widget.note.id,
                                    titulo: _titulo.text,
                                    descricao: _descricao.text,
                                    local: _local.text,
                                    horario: _horario.text,
                                    data: widget.note.data));
                              } else {
                                await eventDBS.createItem(EventModel(
                                    titulo: _titulo.text,
                                    descricao: _descricao.text,
                                    local: _local.text,
                                    horario: _horario.text,
                                    data: _data));
                              }
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => ConsultasTab()));
                              setState(() {
                                processing = false;
                              });
                            }
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    String _time;
    bool _clicked = false;
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = '${picked.hour}:${picked.minute}';
        _clicked = true;
        _horario.text = _time;
      });
    }
    return picked;
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descricao.dispose();
    _local.dispose();
    _horario.dispose();
    super.dispose();
  }
}
