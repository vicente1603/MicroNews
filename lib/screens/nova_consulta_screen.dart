import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:micro_news/tabs/chat_tab.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovaConsultaScreen extends StatefulWidget {
  @override
  _ConsultasTabState createState() => _ConsultasTabState();
}

class _ConsultasTabState extends State<NovaConsultaScreen> {
  final DocumentSnapshot snapshot = null;

  final _formKey = new GlobalKey<FormState>();
  final _titulo = new TextEditingController();
  final _descricao = new TextEditingController();
  final _local = new TextEditingController();
  final _data = new TextEditingController();
  final _horario = new TextEditingController();
  String _time = "";

  final _dateFormat = DateFormat("dd/MM/yyyy");
  final _initialDateValue = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
          title: Text("Cadastrar Consulta"),
          centerTitle: true),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      label: Text('SALVAR'),
      icon: Icon(Icons.save),
      onPressed: _save,
    );
  }

  Future _save() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final FirebaseUser user = await auth.currentUser();
      final uid = user.uid;

      setState(() {
        var id = Timestamp.now().nanoseconds.toString().trim() +
            DateTime.now()
                .toString()
                .replaceAll(":", "")
                .replaceAll("-", "")
                .replaceAll(".", "")
                .trim();

        Firestore.instance
            .collection("users")
            .document(uid)
            .collection("consultas")
            .document(id)
            .setData({
          "id": id,
          "titulo": _titulo.text,
          "descricao": _descricao.text,
          "local": _local.text,
          "data": _data.text,
          "horario": _horario.text
        });

        _titulo.text = "";
        _descricao.text = "";
        _local.text = "";
        _data.text = "";
        _horario.text = "";
      });

      Navigator.of(context).pop();
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTitleTextField(),
            _buildDescriptionTextField(),
            _buildLocalTextField(),
            _buildDateTextField(),
            _buildTimeTextField(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      controller: _titulo,
      maxLines: 1,
      decoration: InputDecoration(
        labelText: 'Título',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (text) => text.isEmpty ? 'Título inválido' : null,
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      controller: _descricao,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Descrição',
        prefixIcon: Icon(Icons.description),
      ),
      validator: (text) => text.isEmpty ? 'Descrição inválida' : null,
    );
  }

  Widget _buildLocalTextField() {
    return TextFormField(
      controller: _local,
      minLines: 1,
      decoration: InputDecoration(
        labelText: 'Local',
        prefixIcon: Icon(Icons.location_on),
      ),
      validator: (text) => text.isEmpty ? 'Local inválido' : null,
    );
  }

  Widget _buildDateTextField() {
    return DateTimeField(
      controller: _data,
      format: _dateFormat,
      initialValue: _initialDateValue,
      decoration: InputDecoration(
        labelText: 'Data',
        prefixIcon: Icon(Icons.date_range),
      ),
      validator: (date) => date == null ? 'Data inválida' : null,
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2100),
        );
      },
    );
  }

  Widget _buildTimeTextField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.access_time),
        labelText: "Horário",
        hintText: _horario.text,
      ),
      controller: _horario,
      onTap: () {
        {
          DatePicker.showTimePicker(context,
              theme: DatePickerTheme(
                containerHeight: 210.0,
              ),
              showTitleActions: true, onConfirm: (time) {
            _time = '${time.hour} : ${time.minute}';
            setState(() {
              _horario.text = _time;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.en);
          setState(() {
            _horario.text = _time;
          });
        }
      },
    );
  }
}
