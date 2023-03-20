import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  State<ConnectedDevicesScreen> createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  late FirebaseDatabase database;
  late bool device1;
  late User? user;

  Future<bool> getdeviceState() async {
    final ref = database.ref('${user!.uid}/devices');
    late Map<Object?, Object?> x;
    await ref.get().then((DataSnapshot snapshot) {
      x = snapshot.value as Map<Object?, Object?>;
      device1 = x["device1"].toString() == "on";
    });
    return device1;
  }

  @override
  void initState() {
    // device1 = false;
    database = FirebaseDatabase.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getdeviceState(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Device 1"),
                          Switch(
                            value: device1,
                            onChanged: (val) {
                              final ref = database.ref('${user!.uid}/devices');
                              ref.update({"device1":val==true?"on":"off"});
                              setState(() {
                                device1 = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
