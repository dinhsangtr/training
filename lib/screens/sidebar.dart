import 'package:flutter/material.dart';
import 'package:start/utils/my_shared_prefs.dart';

import '../constants.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SidebarState();
}

class _SidebarState extends State<SideBar> {
  //shared prefs
  MySharedPrefs prefs = MySharedPrefs();

  //value
  String vfaEmail = '';
  String vfaAvatar = 'null';

  @override
  void initState() {
    prefs.get(MySharedPrefs.vfaEmail).then((value) => setState(() {
          vfaEmail = value.toString();
          print(vfaEmail);
        }));
    prefs.get(MySharedPrefs.vfaAvatar).then((value) => setState(() {
          vfaAvatar = value.toString();
          print(vfaAvatar);
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    //
    return Drawer(
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(),
          _buildBody(),
        ],
      ),
    );
  }

  //build header
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
                          'assets/images/default_avt.png',
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
          /*Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () => {Navigator.of(context).pop()},
                  ),
                )*/
        ],
      ),
      decoration: BoxDecoration(color: primaryColor),
    );
  }

  //build ListTile
  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.perm_identity_sharp),
          title: const Text('My Info'),
          onTap: () => {
            Navigator.of(context).pushNamed('/home/myInfo')
          },
        ),
        ListTile(
          leading: const Icon(Icons.view_list),
          title: const Text('Todo List'),
          onTap: () {
            Navigator.of(context).pushNamed('/home/todolist');
          },
        ),
        ListTile(
          leading: const Icon(Icons.border_color),
          title: const Text('Edit Profile'),
          onTap: () => {Navigator.of(context).pop()},
        ),
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
                  '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
