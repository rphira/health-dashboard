// import '/flutter_flow/flutter_flow_animations.dart';
// import '/flutter_flow/flutter_flow_charts.dart';
// import '/flutter_flow/flutter_flow_icon_button.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:healthdashboard/main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

import 'package:flutter/scheduler.dart';
//import 'package:flutter_animate/flutter_animate.dart';
//import 'package:google_fonts/google_fonts.dart';

//import 'package:provider/provider.dart';


class DistanceWidget extends StatefulWidget {
  const DistanceWidget({Key? key}) : super(key: key);



  @override
  _DistanceWidgetState createState() => _DistanceWidgetState();
}

class _DistanceWidgetState extends State<DistanceWidget>
    with TickerProviderStateMixin {
  // late FootStepsModel _model;



  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<double> distance7Days = HealthAppState.distance7Days;
    List date = HealthAppState.dateForgraph;


    double total = 0;
    double average1 = 0.0;
    int average = 0;


    double maximum = distance7Days.reduce(max);
    maximum = double.parse(maximum.toStringAsFixed(3));
    double minimum = distance7Days.reduce(min);
    minimum = double.parse(minimum.toStringAsFixed(3));
    for (var i in distance7Days) {
      total = total + i;
    }
    total = double.parse(total.toStringAsFixed(3));
    average1 = total / 7;
    average1 = double.parse(average1.toStringAsFixed(3));

    String maxdate = date.elementAt(distance7Days.indexOf(maximum));
    String mindate = date.elementAt(distance7Days.indexOf(minimum));
    print("LIST $distance7Days");
    print("max $maximum");
    print("min $maximum");
    print("avg $average1");

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
                  decoration: const BoxDecoration(
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
                                  children:  [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 4),
                                    ),
                                    Text(
                                      'Distance Traveled',
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF14181B),
                                        fontSize: 24,
                                        fontWeight: FontWeight.normal,
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
                                Icons.add_road,
                                color: Colors.green,
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
                            height: 170,
                            child: LineChart(
                              LineChartData(
                                minY: 0,
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
                                    spots: distance7Days.asMap().entries.map((entry) {
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
                    )
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
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                                child: Text(
                                  'Total Distance (Km)',
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
                          padding: EdgeInsetsDirectional.fromSTEB(40, 4, 24, 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                '$total',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  color: Color(0xFF14181B),
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                    'Maximum for the Week (Km)',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$maximum',
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
                                      '$maxdate',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: Color(0xFF57636C),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
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
                                    'Minimum for the Week (Km)',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$minimum',
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
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 4, 0, 0),
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
                                    'Average for the Week (Km)',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$average1',
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
