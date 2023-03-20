import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class Transcript {
  final String? time;
  final String? speech;
  Transcript(this.time, this.speech);
}

class TranscribeScreen extends StatefulWidget {
  const TranscribeScreen({super.key});

  @override
  State<TranscribeScreen> createState() => _TranscribeScreenState();
}

class _TranscribeScreenState extends State<TranscribeScreen> {
  late FirebaseDatabase database;
  late User? user;
  late Map<String?, String?> x;
  Future<Map<String?, String?>> _getTranscript() async {
    final ref = database.ref('${user!.uid}/transcript');
    await ref.get().then((DataSnapshot snapshot) {
      x = Map<String, String>.from(snapshot.value as Map<Object?, Object?>);
    });
    return x;
  }

  @override
  void initState() {
    database = FirebaseDatabase.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: _getTranscript(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Transcript> emotionData = snapshot.data!.entries
                  .map((entry) => Transcript(entry.key, entry.value))
                  .toList();
              emotionData.sort(
                (a, b) => b.time!.compareTo(a.time as String),
              );
              return ListView.builder(
                  physics: const PageScrollPhysics(),
                  itemCount: emotionData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 7.0, left: 20, right: 20, bottom: 5),
                      child: ChatBubble(
                        elevation: 1.5,
                        clipper:
                            ChatBubbleClipper5(type: BubbleType.receiverBubble),
                        backGroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        margin: const EdgeInsets.only(top: 20),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  emotionData[index].time as String,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                              ),
                              Text(
                                emotionData[index].speech as String,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
