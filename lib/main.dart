import 'dart:async';
import 'package:healthdashboard/TrainingDataWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:healthdashboard/Steps.dart';
import 'package:healthdashboard/HeartRateWidget.dart';
import 'package:healthdashboard/SleepScheduleWidget.dart';
import 'package:healthdashboard/CaloriesWidget.dart';
import 'package:healthdashboard/DistanceWidget.dart';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatefulWidget {
  @override
  HealthAppState createState() => HealthAppState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
  HEART_RATE_READY,
  ACTIVE_ENERGY_READY,
  SLEEP_DATA_READY,
  BLOOD_PRESSURE_DIASTOLIC_READY,
  BLOOD_PRESSURE_SYSTOLIC_READY,
  DISTANCE_DELTA,
  ALL_DATA,
}

class HealthAppState extends State<HealthApp> {

  List<HealthDataPoint> heartRateData = [];
  List<HealthDataPoint> activeenergyburned = [];
  List<HealthDataPoint> steps = [];
  List<HealthDataPoint> sleepData = [];
  List<HealthDataPoint> distanceDeltaData = [];
  List<HealthDataPoint> workout = [];
  List<HealthDataPoint> workoutData = [];
  List<HealthDataPoint> calories7 = [];
  List<HealthDataPoint> sleep7 = [];
  List<HealthDataPoint> heartrate7 = [];
  List<HealthDataPoint> _healthDataList = [];
  List<HealthDataPoint> distanceData = [];
  static List<double> distance7Days = [];
  static List<int> stepsForLast7Days = [];
  static List<int> calories7Days =[];
  static List<int> heartrate7Days =[];
  static List<double> sleep7Days =[];
  static List dateForLast7Days = [];
  static List dateForgraph = [];
  static List<num> workoutburned7days = [];
  static List<num> workoutdistance7days = [];
  static Map<String, List<double>> heartRateDataByDay = {};
  AppState _state = AppState.DATA_NOT_FETCHED;

  var date;
  var stepsvalue;
  var activeenergyburnedValue;
  var heartRateValue;
  var sleepAwakeValue;
  var sleepAsleepValue;
  var sleepInBedValue;
  var dataPoint;
  var hours;
  var minutes;
  var distanceDeltaValue;
  var workoutActivityType;
  var totalEnergyBurned;
  var totalDistance;

  // Define the types to get.
  static final types = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.WORKOUT,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA
  ];

  @override
  void initState() {
    super.initState();
    authorize();
    fetchAll();
    performBackgroundFetching();
  }

  // READ and WRITE
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();
  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  void performBackgroundFetching() async{
  // Configure the background fetch
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15, // Fetch interval in minutes
        stopOnTerminate: false,
        enableHeadless: true,
        startOnBoot: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
      ), (String taskId) async {
        await fetchAll();
        BackgroundFetch.finish(taskId);
      },
    ).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });
  }

  Future fetchAll() async{
    //Fetch all the Data
    await fetchStepData();
    await fetchHeartRate();
    await heartRate7Days();
    await fetchActiveEnergyBurned();
    await fetchSleepData();
    await fetchDistanceDelta();
    await fetchWorkout();

    setState(() {
      _state = _healthDataList.isEmpty ? AppState.NO_DATA : AppState.ALL_DATA;
    });
  }

  Future authorize() async {
    // If we are trying to read we require the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions = await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
        await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }

   // setState(() => _state =
   // (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED);
  }

  /// Add some random health data.

  // Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        stepsForLast7Days= [];
        dateForLast7Days = [];
        for (int i = 6; i >= 0; i--) {

          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = today.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch steps data for each day
          List<HealthDataPoint> stepsData = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.STEPS],
          );

          // Calculate total steps for the day
          int totalSteps1 = 0;
          for (var dataPoint in stepsData) {
            String dataPointValue1 = dataPoint.value.toString();
            int parsedValue = int.tryParse(dataPointValue1) ?? 0;

            totalSteps1 += parsedValue;
            date = dataPoint.dateFrom.toString();
            date = date.substring(5,10);

          }
          // Add total steps to the list
          dateForLast7Days.add(date);

          stepsForLast7Days.add(totalSteps1);
        }

        // Retrive Step data
        steps = await health.getHealthDataFromTypes(
          today, // Start date
          now, // End date
          [HealthDataType.STEPS],
        );
        int totalsteps = 0;

        for (dataPoint in steps) {
          if (dataPoint.type == HealthDataType.STEPS) {
            String dataPointValue1 = dataPoint.value.toString();
            int parsedValue = int.tryParse(dataPointValue1) ?? 0;
            totalsteps += parsedValue;
          }
        }
        stepsvalue  = totalsteps;
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      // setState(() {
      // _nofSteps = ((steps == null) ? 0 : steps)!;
      //  _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
      //});
    } else {
      print("Authorization not granted - error in authorization");
      setState(() => _state = AppState.DATA_NOT_FETCHED);
    }
  }

  Future heartRate7Days() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    try {
      bool granted = await health.requestAuthorization([HealthDataType.HEART_RATE]);
      if (granted) {
        // Initialize a Map to hold the heart rate data for each day
        // Map<String, List<double>> heartRateDataByDay = {};

        // Loop through the last 7 days
        for (int i = 6; i >= 0; i--) {
          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = today.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch heart rate data for each day
          List<HealthDataPoint> heartRateData = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.HEART_RATE],
          );

          // Extract heart rate values for the day and add them to the map
          List<double> heartRateValues = [];
          for (var dataPoint in heartRateData) {
            if (dataPoint.type == HealthDataType.HEART_RATE) {
              double parsedValue = double.tryParse(dataPoint.value.toString()) ?? 0.0;
              heartRateValues.add(parsedValue);
            }
          }

          // Add the heart rate values to the map using the date as the key
          String date = startDate.toString().substring(5, 10);
          heartRateDataByDay[date] = heartRateValues;
        }
        // Now you have heart rate data for each day in the map
        // print('Heart rate data for each day: $heartRateDataByDay');
      } else {
        print('Permission denied');
      }
    } catch (error) {
      print("Caught exception in fetchHeartRate: $error");
    }
  }

  Future fetchHeartRate() async {
   // setState(() => _state = AppState.FETCHING_DATA);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {

      bool granted = await health.requestAuthorization([HealthDataType.HEART_RATE]);

      if (granted) {
        heartrate7Days = [];
        dateForLast7Days = [];
        //for history
        for (int i = 6; i >= 0; i--) {

          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = today.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch steps data for each day
          heartrate7 = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.HEART_RATE],
          );

          // Calculate total steps for the day
          double totalCal1 = 0;
          int totalCal2 = 0;
          for (var dataPoint in heartrate7) {
            String dataPointValue2 = dataPoint.value.toString();
            double parsedValue = double.tryParse(dataPointValue2) ?? 0.0;

            totalCal1 = parsedValue;
            totalCal1.round();
            totalCal2 = totalCal1.toInt();
            date = dataPoint.dateFrom.toString();
            date = date.substring(5,10);

          }
          // Add total steps to the list
          dateForLast7Days.add(date);
          heartrate7Days.add(totalCal2);
        }

        // Retrieve heart rate data
        heartRateData = await health.getHealthDataFromTypes(
          today, // Start date
          now, // End date
          [HealthDataType.HEART_RATE],
        );

        for (dataPoint in heartRateData) {
          if (dataPoint.type == HealthDataType.HEART_RATE) {
            heartRateValue = dataPoint.value;
          }
        }
        if (heartRateValue == null) {
          heartRateValue = 0;
        }

      } else {
        print('Permission denied');
      }
    }
    catch (error) {
      print("Caught exception in getTotalStepsInInterval: $error");
    }
    // update the UI to display the results
  //  setState(() {
    //  _state = heartRateData.isEmpty ? AppState.NO_DATA : AppState.HEART_RATE_READY;
   // });
  }
  Future fetchDistanceDelta() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    try {

      //oldcode for main
      bool granted = await health.requestAuthorization([HealthDataType.DISTANCE_DELTA]);
      double distanceDeltaDataValue = 0.0;
      if (granted) {
        distance7Days = [];
        dateForLast7Days = [];
        for (int i = 6; i >= 0; i--) {

          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = midnight.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch steps data for each day
          distanceData = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.DISTANCE_DELTA],
          );

          // Calculate total steps for the day
          double totaldistance = 0;
          for (var dataPoint in distanceData) {
            String dataPointValue1 = dataPoint.value.toString();
            double parsedValue = double.tryParse(dataPointValue1) ?? 0.0;
            totaldistance += parsedValue;


          }
          totaldistance =  totaldistance / 1000;
          totaldistance = double.parse(totaldistance.toStringAsFixed(3));
          // Add total steps to the list

          distance7Days.add(totaldistance);
          date = dataPoint.dateFrom.toString();
          date = date.substring(5,10);
          dateForLast7Days.add(date);

        }
        // Retrieve heart rate data
        distanceDeltaData = await health.getHealthDataFromTypes(
          midnight, // Start date
          now, // End date
          [HealthDataType.DISTANCE_DELTA],
        );
        for (dataPoint in distanceDeltaData) {
          if (dataPoint.type == HealthDataType.DISTANCE_DELTA) {
            String dataPointValue1 = dataPoint.value.toString();
            double parsedValue = double.tryParse(dataPointValue1) ?? 0;
            int parsedValueInt = parsedValue.toInt();

            distanceDeltaDataValue += parsedValueInt;

          }
        }

        distanceDeltaDataValue = distanceDeltaDataValue/1000;
        distanceDeltaValue = distanceDeltaDataValue.toStringAsFixed(2);
        if (distanceDeltaValue == null) {
          distanceDeltaValue = 0;
        }
      } else {
        print('Permission denied');
      }
    }
    catch (error) {
      print("Caught exception in fetchDistanceDelta: $error");
    }
  }
  Future fetchWorkout() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = now.subtract(Duration(days: 2));
    try {
      bool granted = await health.requestAuthorization([HealthDataType.WORKOUT]);

      if (granted) {
        workoutburned7days = [];
        workoutdistance7days = [];
        dateForLast7Days = [];
        for (int i = 6; i >= 0; i--) {
          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = midnight.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch steps data for each day
          workoutData = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.WORKOUT],
          );
          print("WORKOUT $workoutData");
          // Calculate total steps for the day
          num totalEnergyBurned7Days = 0;
          num totalDistance7Days = 0;
          for (dataPoint in workoutData) {
            if (dataPoint.type == HealthDataType.WORKOUT) {
              workoutActivityType = dataPoint.value.workoutActivityType.toString();
              workoutActivityType = workoutActivityType.split('.')[1]; // Extract the part after the dot

              if(dataPoint.value.totalEnergyBurned == null) {
                totalEnergyBurned7Days += 0;
              }
              else if(dataPoint.value.totalEnergyBurned != null) {
                totalEnergyBurned7Days += dataPoint.value.totalEnergyBurned;
              }

              if(dataPoint.value.totalDistance == null) {
                totalDistance7Days += 0;
              }
              else if(dataPoint.value.totalDistance != null) {
                totalDistance7Days += dataPoint.value.totalDistance;
              }

              if(workoutActivityType == null) {
                workoutActivityType = "None";
              }
              if(totalEnergyBurned7Days == null) {
                totalEnergyBurned7Days = 0;
              }
              if(totalDistance7Days == null) {
                totalDistance7Days = 0;
              }
            }
          }

       //  toString using for these onece 2?
         // totaldistance =  totaldistance / 1000;
          //totaldistance = double.parse(totaldistance.toStringAsFixed(3));
          // Add total steps to the list

          workoutburned7days.add(totalEnergyBurned7Days);
          workoutdistance7days.add(totalDistance7Days);
          print('workoutburned7days Data:$workoutburned7days');
          print('workoutdistance7days Data:$workoutdistance7days');
          date = dataPoint.dateFrom.toString();
          date = date.substring(5,10);
          dateForLast7Days.add(date);
        }

        // totalEnergyBurned =
        // Retrieve heart rate data
        workout = await health.getHealthDataFromTypes(
          sevenDaysAgo, // Start date
          now, // End date
          [HealthDataType.WORKOUT],
        );

        for (dataPoint in workout) {
          if (dataPoint.type == HealthDataType.WORKOUT) {

            if(dataPoint.value.workoutActivityType == null) {
              workoutActivityType="None";
            }
            else {
              workoutActivityType =
                  dataPoint.value.workoutActivityType.toString();
              workoutActivityType = workoutActivityType.split('.')[1];
              // Extract the part after the dot
            }
            if (dataPoint.value.totalEnergyBurned == null) {
              totalEnergyBurned = "0";
            }
            else {
              totalEnergyBurned = dataPoint.value.totalEnergyBurned.toString();
            }

            if (dataPoint.value.totalDistance == null) {
              totalDistance = "0";
            }
            else {
              totalDistance = dataPoint.value.totalDistance.toString();
            }

            print("TOTAL ENERGY $totalEnergyBurned");
            print('Total Energy Burned: $totalEnergyBurned');
            print('Workout Activity Type: $workoutActivityType');
          }
        }

      } else {
        print('Permission denied');
      }
    }
    catch (error) {
      print("Caught exception in fetchWorkout: $error");
    }
  }


  Future fetchActiveEnergyBurned() async {
  //  setState(() => _state = AppState.FETCHING_DATA);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    try {

      bool granted = await health.requestAuthorization([HealthDataType.ACTIVE_ENERGY_BURNED]);

      if (granted) {
        calories7Days = [];
        dateForLast7Days = [];
        dateForgraph = [];
        for (int i = 6; i >= 0; i--) {
          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = today.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch steps data for each day
          calories7 = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.ACTIVE_ENERGY_BURNED],
          );

          // Calculate total steps for the day
          double totalCal1 = 0;
          int totalCal2 = 0;
          for (var dataPoint in calories7) {
            String dataPointValue2 = dataPoint.value.toString();

            double parsedValue = double.tryParse(dataPointValue2) ?? 0.0;

            totalCal1 += parsedValue;
            totalCal1.round();
            totalCal2 = totalCal1.toInt();
            date = dataPoint.dateFrom.toString();
            date = date.substring(5,10);

          }
          // Add total steps to the list
          dateForLast7Days.add(date);
          dateForgraph.add(date);
          calories7Days.add(totalCal2);

        }


        //on main data
        // Retrieve heart rate data
        activeenergyburned = await health.getHealthDataFromTypes(
          today, // Start date
          now, // End date
          [HealthDataType.ACTIVE_ENERGY_BURNED],
        );
        //we recive all the Datapoints, to get the Total Calories Burned we add them together
        double totalActiveEnergyBurned = 0.0;

        for (dataPoint in activeenergyburned) {
          if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
            String dataPointValue = dataPoint.value.toString();
            double parsedValue = double.tryParse(dataPointValue) ?? 0.0;
            totalActiveEnergyBurned += parsedValue;

          }
        }

        activeenergyburnedValue = totalActiveEnergyBurned.toInt();
        print("CalDate $dateForLast7Days");
      } else {
        print('Permission denied');
      }
    }
    catch (error) {
      print("Caught exception in getTotalcaloriesInInterval: $error");
    }
    // update the UI to display the results
  //  setState(() {
    //  _state = activeenergyburned.isEmpty ? AppState.NO_DATA : AppState.ACTIVE_ENERGY_READY;
    //});
  }

  Future fetchSleepData() async {
   // setState(() => _state = AppState.FETCHING_DATA);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    try {
      bool granted = await health.requestAuthorization([
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_IN_BED,
      ]);

      if (granted) {
        sleep7Days = [];
        dateForLast7Days = [];
        //list for history
        for (int i = 6; i >= 0; i--) {

          // Calculate the start and end dates for each day in the last 7 days
          DateTime startDate = today.subtract(Duration(days: i));
          DateTime endDate = startDate.add(Duration(days: 1)).subtract(Duration(seconds: 1));

          // Fetch steps data for each day
          sleep7 = await health.getHealthDataFromTypes(
            startDate,
            endDate,
            [HealthDataType.SLEEP_IN_BED],
          );

          // Calculate total steps for the day
          double totalsleep = 0;
          for (var dataPoint in sleep7) {
            String dataPointValue2 = dataPoint.value.toString();
            double parsedValue = double.tryParse(dataPointValue2) ?? 0.0;

            totalsleep += parsedValue;
            date = dataPoint.dateFrom.toString();
            date = date.substring(5,10);

          }
          // Add total steps to the list
          dateForLast7Days.add(date);
          sleep7Days.add(totalsleep);
        }

        //code for mainpage
        DateTime now = DateTime.now();
        DateTime start = now.subtract(Duration(days: 1));

        List<HealthDataPoint> sleepData = await health.getHealthDataFromTypes(
          start,
          now,
          [
            HealthDataType.SLEEP_AWAKE,
            HealthDataType.SLEEP_ASLEEP,
            HealthDataType.SLEEP_IN_BED,
          ],
        );

        // Process the sleep data
        for (HealthDataPoint dataPoint in sleepData) {
          if (dataPoint.type == HealthDataType.SLEEP_AWAKE) {
            // Save the sleep awake value in a variable
            sleepAwakeValue = dataPoint.value;
          } else if (dataPoint.type == HealthDataType.SLEEP_ASLEEP) {
            // Save the sleep asleep value in a variable
            String sleepAsleepValue = dataPoint.value.toString();
            double parsedValue = double.tryParse(sleepAsleepValue) ?? 0.0;

            var oldhours = parsedValue/60;
            hours = oldhours.toInt();
            var oldmins = parsedValue - hours*60;
            minutes = oldmins.toInt();

          } else if (dataPoint.type == HealthDataType.SLEEP_IN_BED) {
            // Save the sleep in bed value in a variable
            sleepInBedValue = dataPoint.value;
          }
        }
        if (hours == null) {
          hours = 0;
          minutes = 0;
        }

      } else {
        print('Permission denied');
      }
    } catch (error) {
      print("Caught exception in fetchSleepData: $error");
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: _healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = _healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text('${p.unitString}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
              trailing: Text(
                  '${(p.value as WorkoutHealthValue).workoutActivityType.name}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorized() {
    return Text('Authorization granted!');
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return Text('Data points inserted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $stepsvalue');
  }

  Widget _heartRateFetched() {
    return Text('Heart Rate: $heartRateData');
  }
  Widget _distanceDeltaFetched() {
    return Text('Heart Rate: $distanceDeltaValue');
  }
  Widget _activeenergyburned() {
    return Text('ENERGY: $activeenergyburnedValue');
  }
  Widget _sleepdata() {
    return Text('AWAKE: $sleepAwakeValue, Asleep: $sleepAsleepValue,  InBed: $sleepInBedValue');
  }

  Widget _dataNotAdded() {
    return Text('Failed to add data');
  }

  Widget _dataNotDeleted() {
    return Text('Failed to delete data');
  }
  Widget _fetchall() {
    return SafeArea(
      top: true,
    child: Column(
    mainAxisSize: MainAxisSize.max,
    children: [
    Container(
    width: double.infinity,
    decoration: const BoxDecoration(
    color: Color(0xFFF1F4F8),
    ),
    //part starts which we dont need
    child: Column(
    mainAxisSize: MainAxisSize.max,
    children: [
    Padding(
    padding: EdgeInsetsDirectional.fromSTEB(24, 25, 16, 0),
    child: Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    const Text(
    'Hello,',
    style: TextStyle(
    fontFamily: 'Outfit',
    color: Color(0xFF14181B),
    fontSize: 30,
    fontWeight: FontWeight.normal,
    ),
    ),

    ],
    ),
    ),

    Container(
    width: double.infinity,
    decoration: BoxDecoration(
    color: Color(0xFFF1F4F8),
    ),
    child: Column(
    mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
    Padding(
    padding:
    EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
    child: Text(
    'Below is the progress you have made recently.',
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
    ],
    ),
    ),

    Padding(
    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
    child: Container(
    width: double.infinity,
    decoration: BoxDecoration(
    color: Colors.white70,
    boxShadow: const [
    BoxShadow(
    blurRadius: 3,
    color: Color(0x33000000),
    offset: Offset(0, 1),
    )
    ],
    borderRadius: BorderRadius.circular(10),
    ),
    )
    ),
    Expanded(
    child: Builder(
      builder: (context)=>GridView(
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
      ),
      scrollDirection: Axis.vertical,
      children: [
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),

        child: GestureDetector(
        onTap: (){
          //stepsForLast7Days=[];
          fetchStepData();
          Navigator.push(
            context,
              MaterialPageRoute(
                  builder: (context) =>FootStepsWidget()),
          );
        },
        child: Container(
        width: double.infinity,
        height: 278,
        decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
        BoxShadow(
        blurRadius: 4,
        color: Color(0x33000000),
        offset: Offset(0, 2),
        )
        ],
        borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Expanded(
        child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
        2, 0, 0, 0),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
        Text(
        'Steps',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.deepPurpleAccent,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        ),
        ),
        Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 4, 0, 0),
        child: Text(
        'Recently',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Color(0xFF95A1AC),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        ),
        ),
        ),
        Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 8, 0, 0),
        child: Text(
        '$stepsvalue',
        // '$(await healthData.fetchStepData())',
        // healthData.fetchStepData(),
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        ),
        ),
        ),
        ],
        ),
        ),
        ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 50, 60),
            child: const Icon(

              Icons.directions_walk,
              color: Colors.black,
              size: 40,
            ),
          ),

        ],
        ),
        ),
        ),
        ),

        ),
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
      child: GestureDetector(
        onTap: (){
          heartRate7Days();
          // fetchHeartRate();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>HeartRateWidget()),
          );
        },
        child: Container(
        width: double.infinity,
        height: 195,
        decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
        BoxShadow(
        blurRadius: 4,
        color: Color(0x33000000),
        offset: Offset(0, 2),
        )
        ],
        borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Expanded(
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        2, 0, 0, 0),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
        Text(
        'Heart Rate',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.deepPurpleAccent,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        ),
        ),

        Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 4, 0, 0),
        child: Text(
        'Recently',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Color(0xFF95A1AC),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        ),
        ),
        ),
        Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 8, 0, 0),
        child: Text(
        '$heartRateValue',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        ),
        ),
        ),
        Text(
        'Times/min',
        style: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        ),
        ),

        ],
        ),
        ),
        ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 10, 80),
          child: const Icon(

            Icons.monitor_heart,
            color: Colors.black,
            size: 40,
          ),
          ),
        ],
        ),
        ),
        ),
      ),
      ),
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
      child: GestureDetector(
        onTap: (){
          fetchSleepData();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>SleepScheduleWidget()),
          );
        },

        child: Container(
        width: double.infinity,
        height: 278,
        decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
        BoxShadow(
        blurRadius: 4,
        color: Color(0x33000000),
        offset: Offset(0, 2),
        )
        ],
        borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Expanded(
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        2, 0, 0, 0),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
        const Text(
        'Sleep',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.deepPurpleAccent,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        ),
        ),
        const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 4, 0, 0),
        child: Text(
        'Recently',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Color(0xFF95A1AC),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        ),
        ),
        ),
        Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        0, 8, 0, 0),
        child: Text(
        '$hours',
        style:TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 32,
        fontWeight:
        FontWeight.w600,
        ),
        ),
        ),
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        14, 18, 0, 0),
        child: Text(
        'Hours',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Colors.black,
        fontSize: 14,
        fontWeight:
        FontWeight.normal,
        ),
        ),
        ),
        ],
        ),
        Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        0, 8, 0, 0),
        child: Text(
        '$minutes',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 20,
        fontWeight:
        FontWeight.w600,
        ),
        ),
        ),
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        8, 13, 0, 0),
        child: Text(
        'Minutes',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Colors.black,
        fontSize: 14,
        fontWeight:
        FontWeight.normal,
        ),
        ),
        ),
        ],
        ),
        ],
        ),
        ),
        ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 30, 98),
            child: const Icon(

              Icons.bedtime,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
        ),
        ),
        ),
      ),
      ),
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),

        child: GestureDetector(
          onTap: (){
          fetchDistanceDelta();
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) =>DistanceWidget()),
          );

          },
          child: Container(
          width: double.infinity,
          height: 195,
          decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
          BoxShadow(
          blurRadius: 4,
          color: Color(0x33000000),
          offset: Offset(0, 2),
          )
          ],
          borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
          child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
          Expanded(
          child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
          2, 0, 0, 0),
          child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
          const Text(
          'Distance Traveled',
          style: TextStyle(
          fontFamily: 'Outfit',
          color: Colors.deepPurpleAccent,
          fontSize: 24,
          fontWeight: FontWeight.w500,
          ),
          ),
          const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
          0, 4, 0, 0),
          child: Text(
          'Recently',
          style: TextStyle(
          fontFamily: 'Readex Pro',
          color: Color(0xFF95A1AC),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          ),
          ),
          ),
          Row(
          mainAxisSize: MainAxisSize.max,
          children: [
          Padding(
          padding:
          EdgeInsetsDirectional.fromSTEB(
          0, 8, 0, 0),
          child: Text(
          '$distanceDeltaValue',
          style:TextStyle(
          fontFamily: 'Outfit',
          color: Colors.black,
          fontSize: 32,
          fontWeight:
          FontWeight.w600,
          ),
          ),
          ),
          Padding(
          padding:
          EdgeInsetsDirectional.fromSTEB(
          15, 16, 0, 0),
          child: Text(
          'Km',
          style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          ),
          ),
          ),
          ],
          ),
          ],
          ),
          ),
          ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  0, 0, 25, 80),
              child: const Icon(

                Icons.add_road,
                color: Colors.black,
                size: 40,
              ),
            )
          ],
          ),

          ),
      ),
        ),
      ),
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
      child: GestureDetector(
        onTap: (){
          fetchActiveEnergyBurned();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>CaloriesWidget()),
          );
        },
        child: Container(
        width: double.infinity,
        height: 278,
        decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
        BoxShadow(
        blurRadius: 4,
        color: Color(0x33000000),
        offset: Offset(0, 2),
        )
        ],
        borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Expanded(
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        2, 0, 0, 0),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
        const Text(
        'Calories Burned',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.deepPurpleAccent,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        ),
        ),
        const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 4, 0, 0),
        child: Text(
        'Recently',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Color(0xFF95A1AC),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        ),
        ),
        ),
        Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        0, 8, 0, 0),
        child: Text(
        '$activeenergyburnedValue',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 32,
        fontWeight:
        FontWeight.w600,
        ),
        ),
        ),
        ],
        ),
        Row(
        mainAxisSize: MainAxisSize.max,
        children: const [
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        0, 10, 0, 0),
        child: Text(
        'Cal',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Colors.black,
        fontSize: 14,
        fontWeight:
        FontWeight.normal,
        ),
        ),
        ),
        ],
        ),
        ],
        ),
        ),
        ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 30, 95),
            child: const Icon(

              Icons.fireplace,
              color: Colors.black,
              size: 40,
            ),
          )
        ],
        ),
        ),
        ),
      ),
      ),
      Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
      child: GestureDetector(
        onTap: (){
          fetchWorkout();
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>TrainingDataWidget()),
          );
        },
        child: Container(
        width: double.infinity,
        height: 195,
        decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
        BoxShadow(
        blurRadius: 4,
        color: Color(0x33000000),
        offset: Offset(0, 2),
        )
        ],
        borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
        Expanded(
        child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        2, 0, 0, 0),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
        const Text(
        'Workout',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.deepPurpleAccent,
        fontSize: 24,
        fontWeight: FontWeight.w500,
        ),
        ),
        const Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
        0, 4, 0, 0),
        child: Text(
        'Recently',
        style: TextStyle(
        fontFamily: 'Readex Pro',
        color: Color(0xFF95A1AC),
        fontSize: 14,
        fontWeight: FontWeight.w500,
        ),
        ),
        ),
        Row(
        mainAxisSize: MainAxisSize.max,
        children:  [
        Padding(
        padding:
        EdgeInsetsDirectional.fromSTEB(
        0, 8, 0, 0),
        child: Text('$workoutActivityType',
        style: TextStyle(
        fontFamily: 'Outfit',
        color: Colors.black,
        fontSize: 12,
        fontWeight:
        FontWeight.w600,
        ),
        ),
        ),
        ],
        ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children:  [
          Padding(
            padding:
            EdgeInsetsDirectional.fromSTEB(
                0, 8, 0, 0),
            child: Text(
              '$totalEnergyBurned',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.black,
                fontSize: 20,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding:
            EdgeInsetsDirectional.fromSTEB(
                0, 13, 0, 0),
            child: Text(
              ' Cal',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                color: Colors.black,
                fontSize: 14,
                fontWeight:
                FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding:
            EdgeInsetsDirectional.fromSTEB(
                8, 8, 0, 0),
            child: Text(
              '$totalDistance',
              style: TextStyle(
                fontFamily: 'Outfit',
                color: Colors.black,
                fontSize: 20,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding:
            EdgeInsetsDirectional.fromSTEB(
                0, 13, 0, 0),
            child: Text(
              ' m',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                color: Colors.black,
                fontSize: 14,
                fontWeight:
                FontWeight.normal,
              ),
            ),
          ),
        ],
        ),
        ],
        ),
        ),
        ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
                0, 0, 20, 90),
            child: const Icon(

              Icons.terrain,
              color: Colors.black,
              size: 40,
            ),
          )
        ],
        ),
        ),
        ),
      ),
      ),
      ],
      ),
    ),
    ),
    ],),);

  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTHORIZED)
      return _authorized();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.DATA_ADDED)
      return _dataAdded();
    else if (_state == AppState.STEPS_READY)
      return _stepsFetched();
    else if (_state == AppState.HEART_RATE_READY)
      return _heartRateFetched();
    else if (_state == AppState.ACTIVE_ENERGY_READY)
      return _activeenergyburned();
    else if (_state == AppState.SLEEP_DATA_READY)
      return _sleepdata();
    else if (_state == AppState.DATA_NOT_ADDED)
      return _dataNotAdded();
    else if (_state == AppState.DATA_NOT_DELETED)
      return _dataNotDeleted();
    else if (_state == AppState.ALL_DATA)
      return _fetchall();
    else
      return _contentNotFetched();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:
          Center(
              child: const Text('Health Dashboard')),
        ),
        body: _fetchall()

      ),
    );
  }
}
