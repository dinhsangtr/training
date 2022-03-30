import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'custom_progress_indicator.dart';

///------------------------------------BODY-------------------------------------
//border top
BoxDecoration createDefaultBoxDecoration() {
  return const BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
  );
}

//radius
Widget createBody({Widget? child}) {
  return Container(
    color: primaryColor,
    child: Container(
      decoration: createDefaultBoxDecoration(),
      child: child,
    ),
  );
}


///------------------------------------APPBAR-----------------------------------
PreferredSizeWidget? createAppbar(BuildContext context,
    {String? title, Color? color, Widget? leading}) {
  return AppBar(
    backgroundColor: color ?? primaryColor,
    elevation: 0,
    centerTitle: true,
    leading: leading ??
        IconButton(
          color: color == null ? Colors.white : textColor,
          icon: const Icon(Icons.arrow_back_ios, size: 20.0),
          onPressed: () async => Navigator.of(context).pop(),
        ),
    title: Text(
      title ?? '',
      style: TextStyle(color: color == null ? Colors.white : textColor),
    ),
  );
}

///---------------------------BORDER ITEM MAIN_SCREEN---------------------------
BorderRadius borderRadius(
    double topLeft, double topRight, double bottomRight, double bottomLeft) {
  return BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomRight: Radius.circular(bottomRight),
    bottomLeft: Radius.circular(bottomLeft),
  );
}

///-----------------------------------------------------------------------------
void showLoaderDialog(BuildContext context) {
  AlertDialog alert = const AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: CustomProgressIndicatorWidget(),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
