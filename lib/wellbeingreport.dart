import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pie_chart/pie_chart.dart';

Map<String, double> dataMap = {
  "happy": 0,
  "neutral": 0,
  "sad": 0,
  "angry": 0,
  "fear": 0,
  "disgust": 0,
  "surprise": 0,
};

class Emotion {
  final DateTime? time;
  final String? emotion;
  Emotion(this.time, this.emotion);
}

class WellbeingScreen extends StatefulWidget {
  const WellbeingScreen({super.key});

  @override
  State<WellbeingScreen> createState() => _WellbeingScreenState();
}

class _WellbeingScreenState extends State<WellbeingScreen> {
  late FirebaseDatabase database;
  late User? user;
  int menuval = 0;
  Future<int> getreport() async {
    dataMap = {
      "happy": 0,
      "neutral": 0,
      "sad": 0,
      "angry": 0,
      "fear": 0,
      "disgust": 0,
      "surprise": 0,
    };
    final ref = database.ref('${user!.uid}/emotionreport');
    late Map<Object?, Object?> x;
    await ref.get().then((DataSnapshot snapshot) {
      x = snapshot.value as Map<Object?, Object?>;
      dataMap["happy"] = double.parse(x["happy"].toString());
      dataMap["neutral"] = double.parse(x["neutral"].toString());
      dataMap["sad"] = double.parse(x["sad"].toString());
      dataMap["angry"] = double.parse(x["angry"].toString());
      dataMap["fear"] = double.parse(x["fear"].toString());
      dataMap["disgust"] = double.parse(x["disgust"].toString());
      dataMap["surprise"] = double.parse(x["surprise"].toString());
    });
    return 1;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<int> getweekreport() async {
    late List<Emotion> weeklydata;
    dataMap = {
      "happy": 0,
      "neutral": 0,
      "sad": 0,
      "angry": 0,
      "fear": 0,
      "disgust": 0,
      "surprise": 0,
    };
    final ref = database.ref('${user!.uid}/emotionlist');
    late Map<Object?, Object?> x;
    await ref.get().then((DataSnapshot snapshot) {
      x = snapshot.value as Map<Object?, Object?>;
      weeklydata = x.entries
          .map((entry) => Emotion(
              DateTime.parse(entry.key as String), entry.value as String?))
          .toList();
    });
    for (var x in weeklydata) {
      if (daysBetween(x.time as DateTime, DateTime.now()) <= 7) {
        dataMap[x.emotion as String] = (dataMap[x.emotion as String]! + 1);
      }
    }
    return 1;
  }

  Future<int> getmonthreport() async {
    late List<Emotion> monthlylydata;
    dataMap = {
      "happy": 0,
      "neutral": 0,
      "sad": 0,
      "angry": 0,
      "fear": 0,
      "disgust": 0,
      "surprise": 0,
    };
    final ref = database.ref('${user!.uid}/emotionlist');
    late Map<Object?, Object?> x;
    await ref.get().then((DataSnapshot snapshot) {
      x = snapshot.value as Map<Object?, Object?>;
      monthlylydata = x.entries
          .map((entry) => Emotion(
              DateTime.parse(entry.key as String), entry.value as String?))
          .toList();
    });
    for (var x in monthlylydata) {
      if (daysBetween(x.time as DateTime, DateTime.now()) <= 30) {
        dataMap[x.emotion as String] = (dataMap[x.emotion as String]! + 1);
      }
    }
    return 1;
  }

  @override
  void initState() {
    menuval = 2;
    database = FirebaseDatabase.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              initialValue: menuval,
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.redAccent,
              ),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Last Week"),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Last Month"),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text("All Time"),
                  ),
                ];
              },
              onSelected: (value) async {
                if (value == 0) {
                  await getweekreport();
                  setState(() {
                    menuval = 0;
                  });
                  // print("My account menu is selected.");
                } else if (value == 1) {
                  await getmonthreport();
                  setState(() {
                    menuval = 1;
                  });
                  // print("Settings menu is selected.");
                } else if (value == 2) {
                  await getreport();
                  setState(() {
                    menuval = 2;
                  });
                  // print("Logout menu is selected.");
                }
              }),
        ],
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
          future: menuval == 0
              ? getweekreport()
              : menuval == 1
                  ? getmonthreport()
                  : getreport(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PieChart(
                  legendOptions: const LegendOptions(
                      legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  dataMap: dataMap);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
