import 'package:flutter/material.dart';

class ScreenC extends StatelessWidget {
  const ScreenC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('C'),
            centerTitle: true,
            backgroundColor: Colors.redAccent.withOpacity(0.7)
          ),
          body: Container()),
    );
  }
}
