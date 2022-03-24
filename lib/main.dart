import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/screens/add_item_screen.dart';
import 'package:start/screens/info_screen.dart';
import 'package:start/screens/todo_screen.dart';
import 'package:start/utils/my_shared_prefs.dart';

import 'utils/graphql_config.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MySharedPrefs prefs = MySharedPrefs();
  bool isRememberLogin = false;
  String accessToken = '';


  _getAccessToken() async {
    String tokenType = await prefs.get(MySharedPrefs.token_type) ?? '';
    String token = await prefs.get(MySharedPrefs.token) ?? '';
    accessToken = tokenType + ' ' + token;
    print(tokenType + ' ' + token);
  }

  _getStatusRemember() async {
    isRememberLogin = await prefs.get(MySharedPrefs.isRemember) ?? false;
    print('Remember Login: ' + isRememberLogin.toString());
  }

  @override
  void initState() {
    _getStatusRemember();
    _getAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.query(accessToken),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => const LoginScreen(),
            '/home': (BuildContext context) => const MainScreen(),
            '/home/todolist': (BuildContext context) => const TodoScreen(),
            '/home/todolist/additem': (BuildContext context) => const AddItemScreen(),
            '/home/myInfo': (BuildContext context) => const InfoScreen(),
          },
          home: isRememberLogin == true
              ? const MainScreen()
              : const LoginScreen()),
    );
  }
}
