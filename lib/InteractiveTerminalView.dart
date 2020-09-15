import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

class InteractiveTerminalView extends StatefulWidget {
  InteractiveTerminalView({@required this.streamController, @required this.process});

  final StreamController<List> streamController;
  final Process process;
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() => _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

  @override
  _InteractiveTerminalViewState createState() => _InteractiveTerminalViewState();
}

class _InteractiveTerminalViewState extends State<InteractiveTerminalView> {
  TextEditingController tec = TextEditingController();
  FocusNode fn = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 900,
      height: 125,
      padding: EdgeInsets.all(2.0),
      color: Colors.grey[900],
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: StreamBuilder(
              stream: widget.streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]),
                      ),
                    ),
                  );
                }
                // Scroll to Bottom
                WidgetsBinding.instance.addPostFrameCallback((_) => widget._scrollToBottom());
                return Scrollbar(
                  child: ListView.builder(
                    controller: widget._scrollController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (c, i) {
                      return Text(snapshot.data[i].trim(), style: TextStyle(color: Colors.white));
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(2.0),
              color: Colors.black,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 800,
                    height: 50,
                    child: TextField(
                      controller: tec,
                      focusNode: fn,
                      style: TextStyle(fontSize: 12.0, color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                        hintText: "Your response goes here (if needed)",
                        hintStyle: TextStyle(fontSize: 12.0, color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.0),
                  RaisedButton(
                    color: Colors.green[700],
                    child: Text("Send", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (tec.text != "") widget.process.stdin.writeln(tec.text);
                      tec.clear();
                      fn.unfocus();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
