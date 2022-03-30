import 'package:flutter/material.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';
import 'package:start/data/sharedprefs/shared_preference_helper.dart';
import 'package:start/screens/login/login_screen.dart';

import '../../constants/constants.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SidebarState();
}

class _SidebarState extends State<SideBar> {
  //shared prefs
  SharedPreferencesHelper prefs = SharedPreferencesHelper();

  //value
  String vfaEmail = '';
  String vfaAvatar = 'null';

  _getData()  {
    prefs.get(MySharedPrefs.vfaEmail).then((value) => setState(() {
      vfaEmail = value.toString();
      print(vfaEmail);
    }));
    prefs.get(MySharedPrefs.vfaAvatar).then((value) => setState(() {
      vfaAvatar = value.toString();
      print(vfaAvatar);
    }));
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: [
        Column(
          children: <Widget>[
            _buildDrawerHeader(),
            _buildBody(),
          ],
        ),
        _buildButtonClose(),
      ],
    ));
  }

  ///---------------------------------DrawerHeader------------------------------
  Widget _buildDrawerHeader() {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 12),
                ClipOval(
                  child: vfaAvatar == 'null'
                      ? Image.asset(
                          'assets/images/default_avatar.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          vfaAvatar,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 12),
                Text(vfaEmail),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(color: primaryColor),
    );
  }

  ///-----------------------------------Body------------------------------------
  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.perm_identity_sharp),
          title: const Text('My Profile'),
          onTap: () => {Navigator.of(context).pushNamed('/home/myInfo')},
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: const Text('My Timeline'),
          onTap: () => {Navigator.of(context).pushNamed('/home/myTimeline')},
        ),
        ListTile(
          leading: const Icon(Icons.view_list),
          title: const Text('Todo List'),
          onTap: () {
            Navigator.of(context).pushNamed('/home/todolist');
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.border_color),
        //   title: const Text('Edit Profile'),
        //   onTap: () => {Navigator.of(context).pop()},
        // ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () => _showAlertDialog(),
        ),
      ],
    );
  }

  //Dialog
  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Now?'),
        content: const Text('Do you want to exit Vitalify App?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              await prefs.destroy();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.route, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  ///---------------------------------------------------------------------------
  _buildButtonClose() {
    return Positioned(
      bottom: 30,
      right: 0,
      left: 0,
      child: Container(
        alignment: Alignment.center,
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 25,
            child: const Icon(Icons.arrow_back_ios_outlined,
                color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
