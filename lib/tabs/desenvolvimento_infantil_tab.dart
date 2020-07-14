import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/screens/registro_imc_screen.dart';

class DesenvolvimentoInfantilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(text: "Gráfico"),
              Tab(text: "Lista"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Scaffold(
              body: SingleChildScrollView(
                child: sample6(context),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegistroImcScreen()));
                },
              ),
            ),
            Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  child: Center(
                    child: Text("Lista"),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegistroImcScreen()));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

//MAIN SAMPLE
Widget sample6(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blueAccent,
          Colors.white,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bezier Chart",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildChart(
          BezierChartScale.MONTHLY,
          context,
          LinearGradient(
            colors: [
              Colors.red[300],
              Colors.red[400],
              Colors.red[400],
              Colors.red[500],
              Colors.red,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        _buildChart(
            BezierChartScale.YEARLY,
            context,
            LinearGradient(
              colors: [
                Colors.purple[300],
                Colors.purple[400],
                Colors.purple[400],
                Colors.purple[500],
                Colors.purple,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ))
      ],
    ),
  );
}

_buildChart(
    BezierChartScale scale, BuildContext context, LinearGradient gradient) {
  final fromDate = DateTime(2012, 11, 22);
  final toDate = DateTime.now();

  final date1 = DateTime.now().subtract(Duration(days: 2));
  final date2 = DateTime.now().subtract(Duration(days: 3));

  final date3 = DateTime.now().subtract(Duration(days: 300));
  final date4 = DateTime.now().subtract(Duration(days: 320));

  final date5 = DateTime.now().subtract(Duration(days: 650));
  final date6 = DateTime.now().subtract(Duration(days: 652));

  return Center(
    child: Card(
      elevation: 10,
      margin: EdgeInsets.all(25.0),
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          bezierChartScale: scale,
          fromDate: fromDate,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Duty",
              onMissingValue: (dateTime) {
                if (dateTime.year.isEven) {
                  return 20.0;
                }
                return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: 10, xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
                DataPoint<DateTime>(value: 100, xAxis: date3),
                DataPoint<DateTime>(value: 100, xAxis: date4),
                DataPoint<DateTime>(value: 40, xAxis: date5),
                DataPoint<DateTime>(value: 47, xAxis: date6),
              ],
            ),
            BezierLine(
              label: "Flight",
              lineColor: Colors.black26,
              onMissingValue: (dateTime) {
                if (dateTime.month.isEven) {
                  return 10.0;
                }
                return 3.0;
              },
              data: [
                DataPoint<DateTime>(value: 20, xAxis: date1),
                DataPoint<DateTime>(value: 30, xAxis: date2),
                DataPoint<DateTime>(value: 150, xAxis: date3),
                DataPoint<DateTime>(value: 80, xAxis: date4),
                DataPoint<DateTime>(value: 45, xAxis: date5),
                DataPoint<DateTime>(value: 45, xAxis: date6),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundGradient: gradient,
            footerHeight: 35.0,
          ),
        ),
      ),
    ),
  );
}
