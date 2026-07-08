import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthdashboard/main.dart';
import 'dart:math';

class HeartRateWidget extends StatefulWidget {
  const HeartRateWidget({Key? key}) : super(key: key);

  @override
  _HeartRateWidgetState createState() => _HeartRateWidgetState();
}

class _HeartRateWidgetState extends State<HeartRateWidget>
    with TickerProviderStateMixin {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    Map<String, List<double>> heartRateData = HealthAppState.heartRateDataByDay;
    List<double> minimums = [];
    List<double> maximums = [];
    List <int> averages = [];
    List date = HealthAppState.dateForgraph;

    int weekAverage = 0;
    double weekMaximum = 0;
    double weekMinimum = 0;
    double weekTotal = 0;
    double avIntermediate = 0;

    for (var i in heartRateData.values) {
      if (i.isNotEmpty) {
        minimums.add(i.reduce(min));
        maximums.add(i.reduce(max));
        double total = 0;
        double averageTest = 0;
        int average = 0;

        for (var j in i) {
          total = total + j;
        }

        averageTest = total / i.length;
        average = averageTest.toInt();
        averages.add(average);
      }

      else {
        minimums.add(0);
        maximums.add(0);
        averages.add(0);
      }
    }

    weekMaximum =  maximums.reduce(max);
    weekMinimum = minimums.reduce(min);

    int maxDisplay = weekMaximum.toInt();
    int minDisplay = weekMinimum.toInt();

    for (var i in averages) {
      weekTotal = weekTotal + i;
    }

    avIntermediate = weekTotal / averages.length;
    weekAverage = avIntermediate.toInt();

    String maxDate = date.elementAt(maximums.indexOf(weekMaximum));
    String minDate = date.elementAt(minimums.indexOf(weekMinimum));

    if(weekMinimum == 0) {
      minDate = "Unmeasured";
    }

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      String text;
      switch (value.toInt()) {
        case 0:
          text = date[0];
          break;
        case 1:
          text = date[1];
          break;
        case 2:
          text = date[2];
          break;
        case 3:
          text = date[3];
          break;
        case 4:
          text = date[4];
          break;
        case 5:
          text = date[5];
          break;
        case 6:
          text = date[6];
          break;
        default:
          return Container();
      }

      return FittedBox(
        child:
          Transform.rotate(
          angle: -2*pi,
          child: Text(
          text, style: TextStyle(
            fontSize: 11),
        ),
      ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          automaticallyImplyLeading: true,
          leading: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              // context.pushNamed('HealthDataList');
            },
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_sharp,
                color: Colors.black,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 32, 16, 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 4),
                                      child: Text(
                                        'Heart Rate',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF14181B),
                                          fontSize: 24,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Your recent activity is below.',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF14181B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              color: Colors.transparent,
                              // borderRadius: 30,
                              // borderWidth: 1,
                              // buttonSize: 60,
                              icon: Icon(
                                Icons.monitor_heart,
                                color: Colors.deepOrange,
                                size: 40,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          child: Column(
                            children: [
                              Expanded(
                                child: LineChart(
                                    LineChartData(
                                      minY: 0,
                                      maxY: 200,
                                      titlesData:
                                      FlTitlesData(
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false,),
                                          axisNameWidget: Text("Heart Rate (BPM)"),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: true, getTitlesWidget: leftTitleWidgets, reservedSize: 15, interval: 1),
                                          axisNameWidget: Text("Date"),
                                        ),
                                        topTitles: AxisTitles(
                                            sideTitles: SideTitles(showTitles: false)
                                        ),
                                      ),
                                      borderData: FlBorderData(show: true),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: averages.asMap().entries.map((entry) {
                                            return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                          }).toList(),
                                          isCurved: false,
                                          barWidth: 2,
                                          color: Colors.purpleAccent,
                                        ),
                                        LineChartBarData(
                                          spots: maximums.asMap().entries.map((entry) {
                                            return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                          }).toList(),
                                          isCurved: false,
                                          barWidth: 2,
                                          color: Colors.lightGreenAccent,
                                        ),
                                        LineChartBarData(
                                          spots: minimums.asMap().entries.map((entry) {
                                            return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                          }).toList(),
                                          isCurved: false,
                                          barWidth: 2,
                                          color: Colors.lightBlueAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.purpleAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Average', style: TextStyle(color: Colors.purpleAccent)),
                                  const SizedBox(width: 16),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.lightGreenAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Maximum', style: TextStyle(color: Colors.lightGreenAccent)),
                                  const SizedBox(width: 16),
                                  Container(
                                    width: 10,
                                    height: 10,
                                    color: Colors.lightBlueAccent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text('Minimum', style: TextStyle(color: Colors.lightBlueAccent)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          color: Color(0x33000000),
                          offset: Offset(0, 1),
                        )
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: Color(0x32000000),
                        offset: Offset(0, 1),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(40, 20, 24, 13),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Highest Heartrate',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$maxDisplay',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
                                    child: Text(
                                      '$maxDate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF57636C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 4,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                          color: Color(0xFFE0E3E7),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(40, 20, 24, 13),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lowest Heartrate',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$minDisplay',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
                                    child: Text(
                                      '$minDate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF57636C),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 4,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                          color: Color(0xFFE0E3E7),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(40, 20, 24, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Average Heartrate',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$weekAverage',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
