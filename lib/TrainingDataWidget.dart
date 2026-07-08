// import '/flutter_flow/flutter_flow_animations.dart';
// import '/flutter_flow/flutter_flow_charts.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:percent_indicator/percent_indicator.dart';
import 'package:healthdashboard/main.dart';

// import 'training_data_model.dart';
// export 'training_data_model.dart';

class TrainingDataWidget extends StatefulWidget {
  const TrainingDataWidget({Key? key}) : super(key: key);

  @override
  _TrainingDataWidgetState createState() => _TrainingDataWidgetState();
}

class _TrainingDataWidgetState extends State<TrainingDataWidget>
    with TickerProviderStateMixin {
  // late TrainingDataModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    List<num> workoutburned7days = HealthAppState.workoutburned7days;
    List<num>workoutdistance7days = HealthAppState.workoutdistance7days;
    List date = HealthAppState.dateForgraph;
    num calTotal = 0;
    num distTotal = 0;
    for (var i in workoutburned7days) {
      calTotal = calTotal + i;
    }
    for (var i in workoutdistance7days) {
      distTotal = distTotal + i;
    }
    distTotal = distTotal/1000;
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
        child:Text(
            text, style: TextStyle(
            fontSize: 11)
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
                                        'Workout data this week',
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
                            const Icon(
                              Icons.terrain,
                              color: Colors.green,
                              size: 60,
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          height: 200,
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
                                  axisNameWidget: Text("Calories Burned"),
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
                                  spots: workoutburned7days.asMap().entries.map((entry) {
                                    return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                  }).toList(),
                                  isCurved: false,
                                  barWidth: 3,
                                  color: Colors.purpleAccent,
                                ),
                              ],

                            ),
                          ),

                          
                        ),
                      ),

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                        child: Container(
                          width: double.infinity,
                          height: 200,
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
                                  axisNameWidget: Text("Distance (Km)"),
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
                                  spots: workoutdistance7days.asMap().entries.map((entry) {
                                    return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                  }).toList(),
                                  isCurved: false,
                                  barWidth: 3,
                                  color: Colors.purpleAccent,
                                ),
                              ],

                            ),
                          ),


                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
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
                  decoration: const BoxDecoration(
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
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                                child: Text(
                                  'Distance Ran',
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
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(40, 4, 24, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                '$distTotal Km',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF14181B),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                            ],
                          ),
                        ),

                        const Divider(
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
                                  const Text(
                                    'Calories Burned',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  Text(
                                    '$calTotal',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 30,
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