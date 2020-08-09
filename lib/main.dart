import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
    Process.start('start', ['/wait', '/B', '.\\scripts\\pause.cmd'], runInShell: true, workingDirectory: '.').then((process) {
      process.exitCode.then(print);
      process.stdout.transform(utf8.decoder).listen((data) => print(data));
    });
    */

    return MaterialApp(
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[900],
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 200.0),
              Text(
                'Conscious AI',
                textScaleFactor: 6.0,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 150.0),
              OutlineButton(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                textColor: Colors.white,
                borderSide: BorderSide(color: Colors.white),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ' Install Now ',
                      textScaleFactor: 1.5,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 30.0,
                    ),
                  ],
                ),
                onPressed: () => Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => InstallationScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InstallationScreen extends StatefulWidget {
  @override
  _InstallationScreenState createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text(
          'Conscious AI',
          textScaleFactor: 2.0,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 150),
            Text(
              'Sample Text',
              textScaleFactor: 3.0,
              style: TextStyle(
                color: Colors.green[900],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 100),
            SizedBox(
              height: 10.0,
              width: 900.0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.green[900].withOpacity(0.4),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green[900]),
                value: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
