import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:start/screens/add_item_screen.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const MainScreen(),
          '/home/additem': (BuildContext context) => const AddItemScreen(),
        },
        home: LoginScreen());
  }
}
