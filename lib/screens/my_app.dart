import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/data/network/graphql_client.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';
import 'package:start/screens/home/user/info_screen.dart';
import 'package:start/screens/home/todo/todo_screen.dart';
import 'package:start/store/user/user_store.dart';

import 'home/main_screen.dart';
import 'home/user/my_time_line_screen.dart';
import 'login/login_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserStore _userStore = UserStore();

  @override
  void initState() {
    MySharedPrefs.getAllSharedPrefs().then((value) {
      print(value);
    });
    _userStore.getStatusRemember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphQLConfig.client(),
      child: Observer(
        name: 'global-observer',
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          routes: <String, WidgetBuilder>{
            LoginScreen.route: (BuildContext context) => const LoginScreen(),
            MainScreen.route: (BuildContext context) => const MainScreen(),
            TodoScreen.route: (BuildContext context) => const TodoScreen(),
            InfoScreen.route: (BuildContext context) => const InfoScreen(),
            MyTimeLineScreen.route: (BuildContext context) =>
                const MyTimeLineScreen(),
          },
          home:
              _userStore.isLoggedIn ? const MainScreen() : const LoginScreen(),
        ),
      ),
    );
  }
}
