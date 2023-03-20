import 'dart:ui';
import 'package:emotionizer/login.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:emotionizer/profile.dart';
import 'package:emotionizer/validator.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_background/animated_background.dart';
import 'firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _registerFormKey = GlobalKey<FormState>();
  late FocusNode _focusName;
  late FocusNode _focusEmail;
  late FocusNode _focusPassword;
  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  late bool _passwordvisible;
  @override
  void initState() {
    _focusName = FocusNode();
    _focusEmail = FocusNode();
    _focusPassword = FocusNode();
    _passwordvisible = false;
    super.initState();
  }

  bool _isProcessing = false;
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: const Text('Register'),
        // ),
        body: Stack(
          children: [
            AnimatedBackground(
              // vsync uses singleTicketProvider state mixin.
              vsync: this,
              behaviour: RandomParticleBehaviour(options: particles),
              child: Container(),
            ),
            // Image.asset("assets/ezgif-2-2ee1b6ca89.gif",),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  GlassmorphicContainer(
                    width: MediaQuery.of(context).size.width,
                    height: 350,
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
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Form(
                            key: _registerFormKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  cursorColor: Colors.greenAccent,
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      decorationThickness: 0,
                                      color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                  // autofocus: true,
                                  controller: _nameTextController,
                                  focusNode: _focusName,
                                  validator: (value) => Validator.validateName(
                                    name: value,
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white60)),
                                    hintText: "Name",
                                    hintStyle:
                                        const TextStyle(color: Colors.white60),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent)),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                TextFormField(
                                  cursorColor: Colors.greenAccent,
                                  style: const TextStyle(
                                      decoration: TextDecoration.none,
                                      decorationThickness: 0,
                                      color: Colors.white),
                                  textInputAction: TextInputAction.next,
                                  controller: _emailTextController,
                                  focusNode: _focusEmail,
                                  validator: (value) => Validator.validateEmail(
                                    email: value,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white60)),
                                    hintText: "Email",
                                    hintStyle:
                                        const TextStyle(color: Colors.white60),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent)),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
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
                                    password: value,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _passwordvisible = !_passwordvisible;
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
                                        borderSide:
                                            BorderSide(color: Colors.white60)),
                                    hintText: "Password",
                                    hintStyle:
                                        const TextStyle(color: Colors.white60),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.greenAccent)),
                                    errorBorder: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
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
                                                      MaterialStateProperty.all<Size>(
                                                          const Size(100, 50)),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  18.0),
                                                          side: const BorderSide(
                                                              color:
                                                                  Colors.red))),
                                                  backgroundColor:
                                                      const MaterialStatePropertyAll(
                                                          Colors.redAccent)),
                                              onPressed: () async {
                                                setState(() {
                                                  _isProcessing = true;
                                                });

                                                if (_registerFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  User? user = await FireAuth
                                                      .registerUsingEmailPassword(
                                                    name: _nameTextController
                                                        .text,
                                                    email: _emailTextController
                                                        .text,
                                                    password:
                                                        _passwordTextController
                                                            .text,
                                                  );

                                                  setState(() {
                                                    _isProcessing = false;
                                                  });

                                                  if (user != null) {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            CameraScreen(),
                                                      ),
                                                      ModalRoute.withName('/'),
                                                    );
                                                  }
                                                }
                                              },
                                              child: const Text(
                                                'Sign up',
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Already registered?",
                                        style: TextStyle(color: Colors.white60),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            "Log in",
                                            style: TextStyle(
                                                color: Colors.greenAccent),
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
