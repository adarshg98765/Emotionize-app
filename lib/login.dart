import 'package:animated_background/animated_background.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:emotionizer/devices.dart';
import 'package:emotionizer/profile.dart';
import 'package:emotionizer/register.dart';
import 'package:emotionizer/transcribe.dart';
import 'package:emotionizer/wellbeingreport.dart';
import 'package:emotionizer/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

import 'firebase_auth.dart';

final _formKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _focusEmail = FocusNode();

  final _focusPassword = FocusNode();

  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();

  Future<String?> _initializeFirebase() async {
    return FirebaseAuth.instance.currentUser?.uid;
    // return firebaseApp;
  }

  List<String> cardTitles = [
    "Live Demo",
    "Wellbeing Report",
    "Connected Devices",
    "Transcribe",
  ];
  List<String> cardImages = [
    "assets/24022739.jpg",
    "assets/PieChart.png",
    "assets/Screenshot from 2023-03-09 23-59-10.png",
    "assets/5-Best-Speech-to-Text-APIs-2-e1615383933700.webp"
  ];
  ParticleOptions particles = const ParticleOptions(
    baseColor: Colors.redAccent,
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.1,
    maxOpacity: 0.5,
    particleCount: 15,
    spawnMaxRadius: 10.0,
    spawnMaxSpeed: 20.0,
    spawnMinSpeed: 10,
    spawnMinRadius: 2.0,
  );
  late bool _passwordvisible;
  bool _isProcessing = false;
  @override
  void initState() {
    _passwordvisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _initializeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Scaffold(
                backgroundColor: Colors.black,
                resizeToAvoidBottomInset: false,
                body: Stack(children: [
                  AnimatedBackground(
                    vsync: this,
                    behaviour: RandomParticleBehaviour(options: particles),
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 200),
                        GlassmorphicContainer(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          borderRadius: 20,
                          blur: 20,
                          border: 0,
                          linearGradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFffffff).withOpacity(0.15),
                                const Color(0xFFFFFFFF).withOpacity(0.15),
                              ],
                              stops: const [
                                0.1,
                                1,
                              ]),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFffffff).withOpacity(0.3),
                              const Color((0xFFFFFFFF)).withOpacity(0.3),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        decorationThickness: 0,
                                        color: Colors.white),
                                    textInputAction: TextInputAction.next,
                                    // autofocus: true,
                                    cursorColor: Colors.greenAccent,
                                    controller: _emailTextController,
                                    focusNode: _focusEmail,
                                    validator: (value) =>
                                        Validator.validateEmail(email: value),
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white60)),
                                      hintText: "Email",
                                      hintStyle: const TextStyle(
                                          color: Colors.white60),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.greenAccent)),
                                      errorBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  TextFormField(
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        decorationThickness: 0,
                                        color: Colors.white),
                                    cursorColor: Colors.greenAccent,
                                    textInputAction: TextInputAction.done,
                                    controller: _passwordTextController,
                                    focusNode: _focusPassword,
                                    obscureText: !_passwordvisible,
                                    validator: (value) =>
                                        Validator.validatePassword(
                                            password: value),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 15.0),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _passwordvisible =
                                                !_passwordvisible;
                                          });
                                        },
                                        icon: Icon(
                                          _passwordvisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white60)),
                                      hintText: "Password",
                                      hintStyle: const TextStyle(
                                          color: Colors.white60),
                                      focusedBorder: const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.greenAccent)),
                                      errorBorder: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 38.0),
                                  _isProcessing
                                      ? const CircularProgressIndicator()
                                      : Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ButtonStyle(
                                                  minimumSize:
                                                      MaterialStateProperty.all<
                                                          Size>(
                                                    const Size(100, 50),
                                                  ),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                      side: const BorderSide(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  backgroundColor:
                                                      const MaterialStatePropertyAll(
                                                          Colors.redAccent),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    _isProcessing = true;
                                                  });
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    User? user = await FireAuth
                                                        .signInUsingEmailPassword(
                                                      email:
                                                          _emailTextController
                                                              .text,
                                                      password:
                                                          _passwordTextController
                                                              .text,
                                                      context: context,
                                                    );
                                                    setState(() {
                                                      _isProcessing = false;
                                                    });
                                                    if (user != null) {
                                                      setState(() {});
                                                    }
                                                  }
                                                },
                                                child: const Text(
                                                  'Sign In',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Have not registered?",
                                          style:
                                              TextStyle(color: Colors.white60),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterPage()));
                                          },
                                          child: const Text(
                                            "Sign up.",
                                            style: TextStyle(
                                                color: Colors.greenAccent),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              );
            } else {
              return Scaffold(
                backgroundColor: Colors.black,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    actions: <Widget>[
                      IconButton(
                          onPressed: () async {
                            FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                                ModalRoute.withName("/"));
                          },
                          icon: const Icon(
                            Icons.power_settings_new_outlined,
                            color: Colors.redAccent,
                          ))
                    ]),
                body: Center(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 346,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      scrollPhysics: const BouncingScrollPhysics(),
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: [0, 1, 2, 3].map((i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                if (i == 0) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const CameraScreen()));
                                } else if (i == 2) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const ConnectedDevicesScreen()));
                                } else if (i == 1) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const WellbeingScreen()));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const TranscribeScreen()));
                                }
                              },
                              child: GlassmorphicContainer(
                                width: MediaQuery.of(context).size.width,
                                height: 346,
                                borderRadius: 20,
                                blur: 20,
                                border: 0,
                                linearGradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.redAccent,
                                      Colors.redAccent,
                                    ],
                                    stops: [
                                      0.1,
                                      1,
                                    ]),
                                borderGradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFFffffff).withOpacity(0.3),
                                    const Color((0xFFFFFFFF)).withOpacity(0.3),
                                  ],
                                ),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    // decoration:
                                    //     const BoxDecoration(color: Colors.amber),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          cardImages[i],
                                          height: 260,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.fill,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            cardTitles[i],
                                            style: const TextStyle(
                                                fontSize: 20.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          }),
    );
  }
}
