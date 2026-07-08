import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthdashboard/main.dart';
import 'dart:math';

class SleepScheduleWidget extends StatefulWidget {
  const SleepScheduleWidget({Key? key}) : super(key: key);

  @override
  _SleepScheduleWidgetState createState() => _SleepScheduleWidgetState();
}

class _SleepScheduleWidgetState extends State<SleepScheduleWidget>
    with TickerProviderStateMixin {
  // late SleepScheduleModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    List<double> sleeplist = HealthAppState.sleep7Days;
    List date = HealthAppState.dateForgraph;
    double maximum = sleeplist.reduce(max);
    double minimum = sleeplist.reduce(min);
    double total = 0;
    double average1 = 0.0;
    int average = 0;
    for (var i in sleeplist) {
      total = total + i;
    }
    average1 = total / 7;
    average = average1.toInt();
    int avhours = (average/60).toInt();
    int avminutes = (average-avhours*60).toInt();

    int maxhours = (maximum/60).toInt();
    int maxinutes = (maximum-maxhours*60).toInt();

    int minhours = (minimum/60).toInt();
    int minminutes = (minimum-minhours*60).toInt();

    String maxdate = date.elementAt(sleeplist.indexOf(maximum));
    String mindate = date.elementAt(sleeplist.indexOf(minimum));

    Widget leftTitleWidgets(double value, TitleMeta meta) {
      const style = TextStyle(fontSize: 5,);
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
      // onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
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
                                EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 4),
                                      child: Text(
                                        'Sleep Schedule',
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
                              icon: const Icon(
                                Icons.bedtime,
                                color: Colors.brown,
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
                        padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
                        child: Container(
                          width: double.infinity,
                          height: 170,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
                                maxY: 1000,
                                titlesData:
                                FlTitlesData(
                                  // leftTitles: AxisTitles(
                                  //     sideTitles: SideTitles(showTitles: true)
                                  // ),
                                  rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false,),
                                    axisNameWidget: Text("Sleep (Minutes)"),
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
                                    spots: sleeplist.asMap().entries.map((entry) {
                                      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                    }).toList(),
                                    isCurved: false,
                                    barWidth: 3,
                                    color: Colors.purpleAccent,
                                  ),
                                ],

                              ),
                            )
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
                          padding: EdgeInsetsDirectional.fromSTEB(40, 20, 24, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Average Sleep',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$avhours Hours, $avminutes Minutes',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 28,
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
                          padding: EdgeInsetsDirectional.fromSTEB(40, 20, 24, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Longest Sleep',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$maxhours Hours, $maxinutes Minutes',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
                                    child: Text(
                                      '$maxdate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF57636C),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    40, 20, 24, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Shortest Sleep',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            color: Color(0xFF57636C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '$minhours Hours, $minminutes Minutes',
                                          style: TextStyle(
                                            fontFamily: 'Outfit',
                                            color: Color(0xFF14181B),
                                            fontSize: 28,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0, 4, 0, 0),
                                          child: Text(
                                            '$mindate',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: Color(0xFF57636C),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
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
