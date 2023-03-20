import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:google_speech/google_speech.dart';

final config = RecognitionConfig(
    encoding: AudioEncoding.LINEAR16,
    model: RecognitionModel.basic,
    enableAutomaticPunctuation: true,
    sampleRateHertz: 16000,
    languageCode: 'en-US');
final record = Record();
late List<CameraDescription> cameras;
late XFile? videoFile;
bool _isLoading = true;
bool _isRecording = false;
bool _iscomplete = false;
late FirebaseDatabase database;
final dio = Dio();
late String emo;
late String emoAudio;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late var serviceAccount;
  late var speechToText;
  initfn() async {
    serviceAccount = ServiceAccount.fromString(
        (await rootBundle.loadString('assets/emotionizer-2bfb65c4978f.json')));

    speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }

  final StreamController<int> streamcontroller = StreamController<int>();
  bool percentFlag = false;
  int uploadPercent = 0;
  late User? user;
  CameraController? _cameraController;
  late XFile? file1;
  late String? fileurl;

  _stoprecord() async {
    await record.stop();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    setState(() {
      _isRecording = false;
    });
    File file2 = File(file1!.path);
    List<int> imageBytes = await file2.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    final base64Imagenew = "data:image/jpeg;base64,$base64Image";

    File fileAudio = File("$appDocPath/myFile.wav");
    final speechtotextAudio = fileAudio.readAsBytesSync().toList();
    final responsespeechtoText =
        await speechToText.recognize(config, speechtotextAudio);
    // print(responsespeechtoText.results);
    List<int> audioBytes = await fileAudio.readAsBytes();
    String base64Audio = base64Encode(audioBytes);
    // print(base64Image);
    // final storageRef =
    //     FirebaseStorage.instance.ref("${user!.uid}/${file1!.name}");
    // // print(file1!.path);
    // await storageRef.putFile(file2);
    // fileurl = await storageRef.getDownloadURL();
    // print(fileurl);
    setState(() {
      _isLoading = true;
      percentFlag = true;
    });
    Response response;
    response = await dio.post('http://43.204.141.57:5000/analyze',
        options: Options(validateStatus: (status) => true, headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: {
          "img_path": base64Imagenew,
          "actions": ["emotion"]
        });
    // print("object");

    // print(response.data["results"][0]["dominant_emotion"]);
    Response audioResponse;
    audioResponse = await dio.post('http://43.204.141.57:5050/analyze',
        onSendProgress: (count, total) {
      uploadPercent = (count / total * 100).toInt();
      streamcontroller.sink.add(uploadPercent);
      // setState(() {});
    },
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: {
          "audio": base64Audio,
        });
    percentFlag = false;
    emoAudio = audioResponse.data["prediction"];
    DateTime datetime = DateTime.now();
    String dateStr = datetime.toString().substring(0, 19);
    // print(dateStr);
    final ref = database.ref('${user!.uid}/emotionlist');
    final reftranscript = database.ref('${user!.uid}/transcript');
    final refemocount = database.ref('${user!.uid}/emotionreport');
    if (response.statusCode == 500) {
      emo = "No face detected";
    } else {
      emo = response.data["results"][0]["dominant_emotion"];
      // await ref
      //     .update({"token": fcmToken});
      await ref
          .update({dateStr: response.data["results"][0]["dominant_emotion"]});
      switch (response.data["results"][0]["dominant_emotion"]) {
        case "happy":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["happy"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"happy": count.toString()});
          break;
        case "neutral":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["neutral"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"neutral": count.toString()});
          break;
        case "sad":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["sad"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"sad": count.toString()});
          break;
        case "angry":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["angry"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"angry": count.toString()});
          break;
        case "fear":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["fear"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"fear": count.toString()});
          break;
        case "disgust":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["disgust"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"disgust": count.toString()});
          break;
        case "surprise":
          int count = 0;
          await refemocount.get().then((DataSnapshot snapshot) {
            var val = snapshot.value as Map<Object?, Object?>;
            var temp = val["surprise"].toString();
            count = int.parse(temp);
          });
          count++;
          refemocount.update({"surprise": count.toString()});
          break;
        default:
      }
      if (responsespeechtoText.results.length != 0) {
        await reftranscript.update({
          dateStr: responsespeechtoText.results[0].alternatives[0].transcript
        });
      }
    }

    setState(() {
      _isLoading = false;
      // _isRecording = false;
      _iscomplete = true;
    });
  }

  _recordVideo() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    setState(() => _isRecording = true);

    file1 = await _cameraController?.takePicture();
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        numChannels: 1,
        path: '$appDocPath/myFile.wav',
        encoder: AudioEncoder.wav, // by default
        bitRate: 128000, // by default
        samplingRate: 16000, // by default
      );
      // sleep(const Duration(seconds: 3));
    }
  }

  _initCamera() async {
    initfn();
    late String? fcmToken;
    fcmToken = await FirebaseMessaging.instance.getToken();

    final ref = database.ref(user!.uid);

    await ref.update({"token": fcmToken});
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.medium);
    await _cameraController!.initialize();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    percentFlag = false;
    _isRecording = false;
    _isLoading = true;
    _iscomplete = false;
    database = FirebaseDatabase.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _cameraController!.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_iscomplete) {
      return Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoAudio),
          Text(emo),
        ],
      ));
    } else {
      if (_isLoading) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircularProgressIndicator(),
                percentFlag
                    ? StreamBuilder<Object>(
                        initialData: 0,
                        stream: streamcontroller.stream,
                        builder: (context, snapshot) {
                          return Text('${snapshot.data}',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16));
                        })
                    : Container()
              ],
            ),
          ),
        );
      } else {
        return Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CameraPreview(_cameraController!),
              Padding(
                padding: const EdgeInsets.all(25),
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  child: Icon(_isRecording ? Icons.stop : Icons.circle),
                  onPressed: () {
                    if (!_isRecording) {
                      _recordVideo();
                    } else {
                      _stoprecord();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }
    }
  }
}
