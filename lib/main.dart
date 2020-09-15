import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'InteractiveTerminalView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAI Installer',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Future<void> _showExitDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Exit Installer'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want close the installer ?'),
              Text('Any background installation won\'t continue after installer is closed.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            color: Colors.green[900],
            child: Text('Yes'),
            onPressed: () {
              //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              // Currently this doesn't work with windows so using exit(0)
              exit(0);
            },
          ),
          FlatButton(
            color: Colors.green[900],
            child: Text('No, continue with installation'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        actions: [
          IconButton(
            tooltip: "Exit",
            hoverColor: Colors.red,
            splashRadius: 20.0,
            icon: Icon(Icons.close),
            onPressed: () {
              _showExitDialog(context);
            },
          ),
          SizedBox(width: 5.0),
        ],
      ),
      body: Container(
        color: Colors.green[900],
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150.0),
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
  String status = 'Installation is starting...';
  double progressValue;

  // ignore: close_sinks
  final StreamController streamController = StreamController<List>.broadcast();
  List<String> dataList = [];
  Process proc;

  void handleStdout(data) {
    if (data.toString().contains('CAI: INSTALLER:')) {
      status = data.toString().substring(15);
      progressValue == null ? progressValue = 0.0 : progressValue += 0.2;
    } else {
      dataList.add(data);
      streamController.add(dataList);
    }
    setState(() {});
  }

  void handleExit(exitCode) {
    status = (exitCode == 0) ? 'Installation Complete !' : 'An unexpected error occured !';
    progressValue = 1.0;
    setState(() {});
  }

  @override
  void initState() {
    Process.start('START', ['/MIN', '/WAIT', '/B', '.\\scripts\\install.cmd'], runInShell: true, workingDirectory: '.').then((process) {
      process.stdout.transform(utf8.decoder).listen((data) => handleStdout(data));
      process.exitCode.then((value) => handleExit(value));
    });
    super.initState();
  }

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
        actions: [
          IconButton(
            tooltip: "Exit",
            hoverColor: Colors.red,
            splashRadius: 20.0,
            icon: Icon(Icons.close),
            onPressed: () {
              _showExitDialog(context);
            },
          ),
          SizedBox(width: 5.0),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              Text(
                status,
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
                  value: progressValue,
                ),
              ),
              SizedBox(height: 50),
              InteractiveTerminalView(
                streamController: streamController,
                process: proc,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
