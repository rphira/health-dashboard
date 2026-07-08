import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:healthdashboard/main.dart';

import 'dart:math';
class CaloriesWidget extends StatefulWidget {
  const CaloriesWidget({Key? key}) : super(key: key);

  @override
  _CaloriesWidgetState createState() => _CaloriesWidgetState();
}

class _CaloriesWidgetState extends State<CaloriesWidget>
    with TickerProviderStateMixin {

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    List<int> caloriesList = HealthAppState.calories7Days;
    List date = HealthAppState.dateForgraph;
    int maximum = caloriesList.reduce(max);
    int minimum = caloriesList.reduce(min);
    int total = 0;
    double average1 = 0.0;
    int average = 0;
    for (var i in caloriesList) {
      total = total + i;
    }
    average1 = total / 7;
    average = average1.toInt();

    String maxdate = date.elementAt(caloriesList.indexOf(maximum));
    String mindate = date.elementAt(caloriesList.indexOf(minimum));

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
                                        'Calories Burned',
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
                                Icons.fireplace,
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
                            height: 170,
                            child: LineChart(

                              LineChartData(
                                minY: 0,
                                maxY: 6000,
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
                                    spots: caloriesList.asMap().entries.map((entry) {
                                      return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                                    }).toList(),
                                    isCurved: false,
                                    barWidth: 3,
                                    color: Colors.purpleAccent,
                                  ),
                                ],

                              ),
                            )
                          // FlutterFlowLineChart(
                          //   data: [
                          //     FFLineChartData(
                          //       xData: List.generate(
                          //           random_data.randomInteger(0, 0),
                          //               (index) => random_data.randomInteger(0, 10)),
                          //       yData: List.generate(
                          //           random_data.randomInteger(0, 0),
                          //               (index) => random_data.randomInteger(0, 10)),
                          //       settings: LineChartBarData(
                          //         color: Color(0xFF4B39EF),
                          //         barWidth: 2,
                          //         isCurved: true,
                          //         preventCurveOverShooting: true,
                          //         dotData: FlDotData(show: false),
                          //         belowBarData: BarAreaData(
                          //           show: true,
                          //           color: Color(0x4C4B39EF),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          //   chartStylingInfo: ChartStylingInfo(
                          //     enableTooltip: true,
                          //     backgroundColor: Colors.white,
                          //     showBorder: false,
                          //   ),
                          //   axisBounds: AxisBounds(),
                          //   xAxisLabelInfo: AxisLabelInfo(
                          //     title: 'Last 24 hours',
                          //     titleTextStyle: FlutterFlowTheme.of(context)
                          //         .bodyMedium
                          //         .override(
                          //       fontFamily: 'Plus Jakarta Sans',
                          //       color: Color(0xFF14181B),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.normal,
                          //     ),
                          //   ),
                          //   yAxisLabelInfo: AxisLabelInfo(
                          //     title: 'Heartrate',
                          //     titleTextStyle: FlutterFlowTheme.of(context)
                          //         .bodyMedium
                          //         .override(
                          //       fontFamily: 'Plus Jakarta Sans',
                          //       color: Color(0xFF14181B),
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.normal,
                          //     ),
                          //   ),
                          // ),
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
                                    'Most Calories Burned',
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
                                    'Least Calories Burned',
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
                                    'Average Calories Burned',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xFF57636C),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '$average',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Color(0xFF14181B),
                                      fontSize: 36,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              // Expanded(
                              //   child: Container(
                              //     width: 120,
                              //     height: 120,
                              //     clipBehavior: Clip.antiAlias,
                              //     decoration: BoxDecoration(
                              //       shape: BoxShape.circle,
                              //     ),
                              //     child: Image.network(
                              //       'https://picsum.photos/seed/563/600',
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),
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
