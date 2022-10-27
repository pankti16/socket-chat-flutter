import 'package:flutter/material.dart';
import 'package:socket_chat/services/socket_services.dart';
import 'package:socket_chat/utils/debugLogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SocketService _socketService = SocketService();
  @override
  void initState() {
    _socketService.initSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SocketService _socketService = SocketService();
  final TextEditingController _msgController = new TextEditingController();
  late List<String> _data = [];

  @override
  void initState() {
    _listenMsg();
    super.initState();
  }

  _listenMsg() {
    try {
      Future.delayed(const Duration(seconds: 1), () {
        _socketService.on('receive_from', (_val) {
          setState(() {
            _data = [..._data, _val];
          });
        });
      });
    } catch (e) {
      debugLogs('error listening message $e');
    }
  }

  _sendMsg() {
    try {
      var _val = _msgController.text.trim();
      if (_val.isNotEmpty) {
        _socketService.emit('send_to', _val);
        _msgController.clear();
      }
    } catch (e) {
      debugLogs('error emitting message $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Socket Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter message',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  flex: 2,
                  child: MaterialButton(
                    color: Colors.blue,
                    height: 60.0,
                    onPressed: () {
                      _sendMsg();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(_data[index]));
                },
                itemCount: _data.length,
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
