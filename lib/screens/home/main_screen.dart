import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:start/data/network/constants/constants.dart';
import 'package:start/data/network/graphql_client.dart';
import 'package:start/screens/home/sidebar.dart';
import 'package:start/utils/toast.dart';
import 'package:start/widgets/app.dart';
import 'package:start/widgets/custom_dialog.dart';

import '../../constants/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateFormat dateFormat = DateFormat("EEEE, dd MMMM yyyy");
  DateTime now = DateTime.now();
  late String today = dateFormat.format(now);

  Future<void> _createActivity(String activityTypes) async {
    await GraphQLConfig.client().value.mutate(
          MutationOptions(
            document: gql(GraphQLConstants.createActivity),
            variables: {
              "input": {
                "activityTypes": activityTypes,
              }
            },
            onError: (OperationException? error) {
              List<GraphQLError> graphqlErrors = error!.graphqlErrors;
              print('Create Activity Error: ' +
                  graphqlErrors.first.message.toString());
              Toast.showSnackBar(context,
                  message: graphqlErrors.first.message.toString());
            },
            onCompleted: (dynamic data) {
              print('Data: ' + (data.toString() != 'null' ? 'Oke' : 'Empty'));

              if (data != null) {
                print(data.toString());
                String message = '';
                if (data['createActivity']['requestResolved'] == true) {
                  message = activityTypes.replaceAll('_', ' ') + ' SUCCESS';
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CustomDialog(message: message, hasButton: false);
                    },
                  );
                } else {
                  message = data['createActivity']['message'];
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return CustomDialog(message: message, hasButton: false);
                    },
                  );
                }
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: const SideBar(),
          appBar: createAppbar(
            context,
            title: 'Vitalify Asia',
            leading: IconButton(
              icon: const Icon(Icons.view_headline),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
          body: Container(
            color: primaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius(20.0, 20.0, 0.0, 0.0),
              ),
              child: Column(
                children: <Widget>[
                  _buildTextTime(),
                  _buildBody(),
                ],
              ),
            ),
          )),
    );
  }

  //build text time
  Widget _buildTextTime() {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
      alignment: Alignment.center,
      child: Text(
        'Today is $today',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //build body
  Widget _buildBody() {
    return GridView.count(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(15),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        _buildItem(
          onTap: () {
            print('Check in');
            _createActivity(GraphQLConstants.checkIn);
          },
          color: Colors.grey.withOpacity(0.5),
          borderRadius: borderRadius(20.0, 20.0, 0.0, 20.0),
          iconData: Icons.arrow_forward_ios,
          title: 'Check in',
        ),
        _buildItem(
          onTap: () {
            print('Check out');
            _createActivity(GraphQLConstants.checkOut);
          },
          color: Colors.green.withOpacity(0.9),
          borderRadius: borderRadius(20.0, 20.0, 20.0, 0.0),
          iconData: Icons.arrow_back_ios,
          title: 'Check out',
          textColor: Colors.white,
        ),
        _buildItem(
          onTap: () {
            print('Go out');
            _createActivity(GraphQLConstants.goOut);
          },
          color: Colors.deepOrange.withOpacity(0.7),
          borderRadius: borderRadius(20.0, 0.0, 20.0, 20.0),
          iconData: Icons.subdirectory_arrow_left,
          title: 'Go out',
          textColor: Colors.white,
        ),
        _buildItem(
          onTap: () {
            print('Come back');
            _createActivity(GraphQLConstants.comeBack);
          },
          color: Colors.grey.withOpacity(0.5),
          borderRadius: borderRadius(0.0, 20.0, 20.0, 20.0),
          iconData: Icons.subdirectory_arrow_right,
          title: 'Come back',
        ),
      ],
    );
  }

  //
  Widget _buildItem({
    required Function()? onTap,
    required Color color,
    required BorderRadius borderRadius,
    required IconData iconData,
    required String title,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              color: textColor ?? Colors.black.withOpacity(0.8),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: textColor ?? Colors.black.withOpacity(0.8),
              ),
            )
          ],
        ),
      ),
    );
  }

  //
  BorderRadius borderRadius(
      double topLeft, double topRight, double bottomRight, double bottomLeft) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomRight: Radius.circular(bottomRight),
      bottomLeft: Radius.circular(bottomLeft),
    );
  }
}
