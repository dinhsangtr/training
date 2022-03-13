import 'package:flutter/material.dart';
import 'package:start/widgets/app.dart';

class ScreenC extends StatelessWidget {
  const ScreenC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: createAppbar(
            context,
            title: 'C',
            leading: const SizedBox(height: 0.0, width: 0.0),
          ),
          body: Container()),
    );
  }
}
