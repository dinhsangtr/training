import 'package:flutter/material.dart';

class ScreenB extends StatelessWidget {
  const ScreenB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('B'),
            centerTitle: true,
            backgroundColor: Colors.redAccent.withOpacity(0.7),
          ),
          body: Container()),
    );
  }
}
