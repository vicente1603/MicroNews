import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/blocs/medicamentos_bloc.dart';
import 'package:micro_news/helper/convert_time.dart';
import 'package:micro_news/models/errors.dart';
import 'package:micro_news/models/medicamento.dart';
import 'package:micro_news/models/tipo_medicamento.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import 'package:micro_news/tabs/medicamentos_tab.dart';
import 'package:micro_news/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:random_string/random_string.dart';

class NovoMedicamentoScreen extends StatefulWidget {
  @override
  _NovoMedicamentoScreenState createState() => _NovoMedicamentoScreenState();
}

class _NovoMedicamentoScreenState extends State<NovoMedicamentoScreen> {
  TextEditingController nameController;
  TextEditingController dosageController;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NewEntryBloc _newEntryBloc;

  GlobalKey<ScaffoldState> _scaffoldKey;

  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    initializeErrorListen();
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Novo medicamento"),
          elevation: 0.0,
        ),
        body: Container(
          child: Provider<NewEntryBloc>.value(
            value: _newEntryBloc,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              children: <Widget>[
                PanelTitle(
                  title: "Nome do medicamento",
                  isRequired: true,
                ),
                TextFormField(
                  maxLength: 12,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
                PanelTitle(
                  title: "Dosagem",
                  isRequired: false,
                ),
                TextFormField(
                  controller: dosageController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                PanelTitle(
                  title: "Tipo do medicamento",
                  isRequired: false,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: StreamBuilder<MedicineType>(
                    stream: _newEntryBloc.selectedMedicineType,
                    builder: (context, snapshot) {
                      return Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MedicineTypeColumn(
                                  type: MedicineType.Frasco,
                                  name: "Frasco",
                                  iconValue: 0xe900,
                                  isSelected:
                                      snapshot.data == MedicineType.Frasco
                                          ? true
                                          : false),
                              MedicineTypeColumn(
                                  type: MedicineType.Pilula,
                                  name: "Pílula",
                                  iconValue: 0xe901,
                                  isSelected:
                                      snapshot.data == MedicineType.Pilula
                                          ? true
                                          : false),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              MedicineTypeColumn(
                                  type: MedicineType.Seringa,
                                  name: "Seringa",
                                  iconValue: 0xe902,
                                  isSelected:
                                      snapshot.data == MedicineType.Seringa
                                          ? true
                                          : false),
                              MedicineTypeColumn(
                                  type: MedicineType.Comprimido,
                                  name: "Comprimido",
                                  iconValue: 0xe903,
                                  isSelected:
                                      snapshot.data == MedicineType.Comprimido
                                          ? true
                                          : false),
                            ],
                          )
                        ],
                      );
                    },
                  ),
                ),
                PanelTitle(
                  title: "Selecão de intervalo",
                  isRequired: true,
                ),
                //ScheduleCheckBoxes(),
                IntervalSelection(),
                PanelTitle(
                  title: "Horário de ínicio",
                  isRequired: true,
                ),
                SelectTime(),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 70.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: RaisedButton(
                      child: Text(
                        "Adicionar",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      color: Colors.blueAccent,
                      onPressed: () {
                        adicionarMedicamento(uid, _globalBloc);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  void adicionarMedicamento(uid, _globalBloc) {
    String medicineName;
    int dosage;
    if (nameController.text == "") {
      _newEntryBloc.submitError(EntryError.NameNull);
      return;
    }
    if (nameController.text != "") {
      medicineName = nameController.text;
    }
    if (dosageController.text == "") {
      _newEntryBloc.submitError(EntryError.Dosage);
      return;
    }
    if (dosageController.text != "") {
      dosage = int.parse(dosageController.text);
    }
    for (var medicine in _globalBloc.medicineList$.value) {
      if (medicineName == medicine.medicineName) {
        _newEntryBloc.submitError(EntryError.NameDuplicate);
        return;
      }
    }
    if (_newEntryBloc.selectedInterval$.value == 0) {
      _newEntryBloc.submitError(EntryError.Interval);
      return;
    }
    if (_newEntryBloc.selectedTimeOfDay$.value == "Nenhum") {
      _newEntryBloc.submitError(EntryError.StartTime);
      return;
    }
    //---------------------------------------------------------
    String medicineType =
        _newEntryBloc.selectedMedicineType.value.toString().substring(13);
    int interval = _newEntryBloc.selectedInterval$.value;
    String startTime = _newEntryBloc.selectedTimeOfDay$.value;

    List<int> intIDs = makeIDs(24 / _newEntryBloc.selectedInterval$.value);
    List<String> notificationIDs =
        intIDs.map((i) => i.toString()).toList(); //for Shared preference

    var id = randomAlphaNumeric(15);

    Firestore.instance
        .collection("users")
        .document(uid)
        .collection("medicamentos")
        .document(id)
        .setData({
      "id": id,
      "idsNotificacoes": notificationIDs,
      "nomeMedicamento": medicineName,
      "dosagem": dosage,
      "tipoMedicamento": medicineType,
      "intervalo": interval,
      "horaInicio": startTime
    });

    Medicine newEntryMedicine = Medicine(
      id: id,
      notificationIDs: notificationIDs,
      medicineName: medicineName,
      dosage: dosage,
      medicineType: medicineType,
      interval: interval,
      startTime: startTime,
    );

    _globalBloc.updateMedicineList(newEntryMedicine);
    scheduleNotification(newEntryMedicine);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MedicamentosTab()));
  }

  void initializeErrorListen() {
    _newEntryBloc.errorState$.listen(
      (EntryError error) {
        switch (error) {
          case EntryError.NameNull:
            displayError("Por favor, insira o nome do medicamento");
            break;
          case EntryError.NameDuplicate:
            displayError("Esse medicamento já está cadastrado");
            break;
          case EntryError.Dosage:
            displayError("Por favor, insira a dosagem do mecicamento");
            break;
          case EntryError.Interval:
            displayError("Por favor, selecione o intervalo do medicamento");
            break;
          case EntryError.StartTime:
            displayError("Por favor, insira o de ínicio do medicamento");
            break;
          default:
        }
      },
    );
  }

  void displayError(String error) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(error),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  List<int> makeIDs(double n) {
    var rng = Random();
    List<int> ids = [];
    for (int i = 0; i < n; i++) {
      ids.add(rng.nextInt(1000000000));
    }
    return ids;
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    await Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => MedicamentosTab()),
    );
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime[0] + medicine.startTime[1]);
    var ogValue = hour;
    var minute = int.parse(medicine.startTime[2] + medicine.startTime[3]);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
      importance: Importance.Max,
      sound: RawResourceAndroidNotificationSound('sound'),
      ledColor: Color(0xFF3EB16F),
      ledOffMs: 1000,
      ledOnMs: 1000,
      enableLights: true,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    for (int i = 0; i < (24 / medicine.interval).floor(); i++) {
      if ((hour + (medicine.interval * i) > 23)) {
        hour = hour + (medicine.interval * i) - 24;
      } else {
        hour = hour + (medicine.interval * i);
      }
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          int.parse(medicine.notificationIDs[i]),
          '${medicine.medicineName}',
          medicine.medicineType.toString() != MedicineType.Nenhum.toString()
              ? 'Está na hora do medicamento ${medicine.medicineName.toLowerCase()}!'
              : 'Está na hora do medicamento!',
          Time(hour, minute, 0),
          platformChannelSpecifics);
      hour = ogValue;
    }
    //await flutterLocalNotificationsPlugin.cancelAll();
  }
}

class IntervalSelection extends StatefulWidget {
  @override
  _IntervalSelectionState createState() => _IntervalSelectionState();
}

class _IntervalSelectionState extends State<IntervalSelection> {
  var _intervals = [
    6,
    8,
    12,
    24,
  ];
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lembrar a cada ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            DropdownButton<int>(
              iconEnabledColor: Colors.blueAccent,
              hint: _selected == 0
                  ? Text(
                      "Selecione",
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    )
                  : null,
              elevation: 4,
              value: _selected == 0 ? null : _selected,
              items: _intervals.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  _selected = newVal;
                  _newEntryBloc.updateInterval(newVal);
                });
              },
            ),
            Expanded(
              child: Text(
                _selected == 1 ? " hora" : " horas",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectTime extends StatefulWidget {
  @override
  _SelectTimeState createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay(hour: 0, minute: 00);
  bool _clicked = false;

  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
        _clicked = true;
        _newEntryBloc.updateTime("${convertTime(_time.hour.toString())}" +
            "${convertTime(_time.minute.toString())}");
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 4),
        child: FlatButton(
          color: Colors.white,
          onPressed: () {
            _selectTime(context);
          },
          child: Center(
            child: Text(
              _clicked == false
                  ? "Selecione o horário"
                  : "${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MedicineTypeColumn extends StatelessWidget {
  final MedicineType type;
  final String name;
  final int iconValue;
  final bool isSelected;

  MedicineTypeColumn(
      {Key key,
      @required this.type,
      @required this.name,
      @required this.iconValue,
      @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewEntryBloc _newEntryBloc = Provider.of<NewEntryBloc>(context);
    return GestureDetector(
      onTap: () {
        _newEntryBloc.updateSelectedMedicine(type);
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.blueAccent : Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 14.0),
                child: Icon(
                  IconData(iconValue, fontFamily: "Ic"),
                  size: 75,
                  color: isSelected ? Colors.white : Colors.blueAccent,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blueAccent : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? Colors.white : Colors.blueAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PanelTitle extends StatelessWidget {
  final String title;
  final bool isRequired;

  PanelTitle({
    Key key,
    @required this.title,
    @required this.isRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 4),
      child: Text.rich(
        TextSpan(children: <TextSpan>[
          TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
          ),
          TextSpan(
            text: isRequired ? " *" : "",
            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
          ),
        ]),
      ),
    );
  }
}
