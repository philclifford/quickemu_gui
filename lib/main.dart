import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quickemu',
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
      home: const MyHomePage(title: 'Quickemu GUI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class QuickgetForm extends StatefulWidget {
  const QuickgetForm({Key? key}) : super(key: key);

  @override
  _QuickgetFormState createState() => _QuickgetFormState();
}

class _QuickgetFormState extends State<QuickgetForm> {
  //final _formKey = GlobalKey<FormState>();
  List<String> osSupport = [];
  List<String> releaseSupport = [];
  String? selectedOs;
  String? selectedRelease;
  _getOsSupport() {
    var result = Process.runSync('quickget', []);
    setState(() {
      osSupport = result.stdout.split("\n")[1].split(" ");
    });
  }
  _releaseSupport(String os) {
    var result = Process.runSync('quickget', [os]);
    setState(() {
      releaseSupport = result.stdout.split("\n")[1].split(" ");
    });
  }
  _quickget(String os, String release) async {
    Process.run('quickget', [os, release]);
  }
  @override
  Widget build(BuildContext context) {
    _getOsSupport();
    return Form(
     // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField(
            value: selectedOs,
            items: osSupport.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value)
              );
            }).toList(),
            hint: const Text('Select OS'),
            onChanged: (String? newValue) {
              setState(() {
                selectedOs = newValue!;
                releaseSupport = [];
                selectedRelease = null;
              });
              if (selectedOs != null) {
                _releaseSupport(selectedOs!);
              }
            },
          ),
          DropdownButtonFormField(
            value: selectedRelease,
            items: releaseSupport.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value)
              );
            }).toList(),
            hint: const Text('Select release'),
            disabledHint: const Text('Select an OS first'),
            onChanged: (String? newValue) {
              setState(() {
                selectedRelease = newValue!;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              _quickget(selectedOs!, selectedRelease!);
            },
            child: const Text('Quick, get!'),
          )
        ],

      )
    );
  }
}


class _MyHomePageState extends State<MyHomePage> {

  void _showQuickgetForm() {
    Navigator.of(context).push(
        MaterialPageRoute<void>(
            builder: (context) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('New VM with Quickget'),
                  ),
                  body: const QuickgetForm()
              );
            }
        )
    );
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
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              'Hi!',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickgetForm,
        tooltip: 'Add VM with quickget',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
