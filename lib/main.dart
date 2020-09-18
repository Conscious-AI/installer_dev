import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
              Process.killPid(InstallScriptProc.proc.pid);
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

abstract class InstallScriptProc {
  static Process proc;
}

class InstallationScreen extends StatefulWidget {
  final int steps = 9;

  // ignore: close_sinks
  final StreamController streamController = StreamController<List>.broadcast();

  @override
  _InstallationScreenState createState() => _InstallationScreenState();
}

class _InstallationScreenState extends State<InstallationScreen> {
  String status = 'Installation is starting...';
  double progressValue;
  List<String> dataList;
  bool isFABVisible;

  void handleStdout(data) {
    if (data.toString().contains('CAI: INSTALLER:')) {
      status = data.toString().substring(15);
      progressValue == null ? progressValue = 0.0 : progressValue += 1.0 / widget.steps;
    } else {
      dataList.add(data);
      widget.streamController.add(dataList);
    }
    setState(() {});
  }

  void handleExit(exitCode) {
    status = (exitCode == 0) ? 'Installation Complete !' : 'An unexpected error occured !';
    setState(() {
      progressValue = 1.0;
      isFABVisible = true;
    });
  }

  @override
  void initState() {
    dataList = [];
    isFABVisible = false;
    Process.start('START', ['/MIN', '/WAIT', '/B', '.\\scripts\\install.cmd'], runInShell: true, workingDirectory: '.').then((process) {
      InstallScriptProc.proc = process;
      process.stdout.transform(utf8.decoder).listen((data) => handleStdout(data));
	  process.stderr.transform(utf8.decoder).listen((data) => print("stderr: $data"));
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
                streamController: widget.streamController,
                process: InstallScriptProc.proc,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: isFABVisible,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
          icon: Icon(Icons.exit_to_app, size: 25.0),
          label: Text("Finish", textScaleFactor: 2.0),
          onPressed: () {
            //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            // Currently this doesn't work with windows so using exit(0)
            exit(0);
          },
        ),
      ),
    );
  }
}
