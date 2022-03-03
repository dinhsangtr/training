import 'package:flutter/material.dart';

class ScreenA extends StatelessWidget {
  const ScreenA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('A'),
            centerTitle: true,
              backgroundColor: Colors.redAccent.withOpacity(0.7),
          ),
          body: Container()),
    );
  }
}
