/*
 * @Author: Hackett 
 * @Date: 2019-07-09 19:18:36 
 * @Last Modified by: Hackett
 * @Last Modified time: 2019-07-09 19:29:51
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frame/frame.dart';

void main() {
  // Initialize the model. Can be done outside a widget, like here.
  var counter = Counter();

  // Here we set up a delayed interaction with the model (increment each
  // 5 seconds), outside of the Flutter widget tree.
  //
  // This is just an example. In a real world app, this could be replaced
  // with a connection to a real-time database, for example.
  Timer.periodic(
    const Duration(seconds: 5),
    (timer) => counter.increment(),
  );

  // Set up a Providers instance.
  var providers = Providers();
  providers.provide(Provider<Counter>.value(counter));

  // Now we're ready to run the app...
  runApp(
    // ... and provide the model to all widgets within.
    ProviderNode(
      providers: providers,
      child: MyApp(),
    ),
  );
}

/// Simplest possible model, with just one field.
class Counter extends ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
    notifyListeners();
  }
}

class UserData extends ChangeNotifier {
  final int id;
  String name = "";

  UserData(this.id) {
    Future.delayed(const Duration(seconds: 10), () => name = "Hackett_" + this.id.toString());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            // Provide looks for an ancestor ProviderNode widget
            // and retrieves its model (Counter, in this case).
            // Then it uses that model to build widgets, and will trigger
            // rebuilds if the model is updated.
            Provide<Counter>(
              builder: (context, child, counter) => Text(
                    '${counter.value}',
                    style: Theme.of(context).textTheme.display1,
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Provide.value is another way to access the model object held
        // by an ancestor ProviderNode. By default, it just returns
        // the current model and doesn't automatically trigger rebuilds.
        // Since this button always looks the same, though, no rebuilds
        // are needed.
        onPressed: () => Provide.value<Counter>(context).increment(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
