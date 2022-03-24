import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/utils/graphql_config.dart';
import 'package:start/utils/my_shared_prefs.dart';
import 'package:start/widgets/app.dart';

import '../constants.dart';
import '../graphql_.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  //shared prefs
  MySharedPrefs prefs = MySharedPrefs();

  String accessToken = '';

  Future<String> _getAccessToken() async {
    String tokenType = await prefs.get(MySharedPrefs.token_type) ?? '';
    String token = await prefs.get(MySharedPrefs.token) ?? '';
    return (tokenType + ' ' + token);
  }

  //
  void _getInfo() async {
    QueryResult queryResult =
        await GraphQLConfig.query(await _getAccessToken()).value.query(
              QueryOptions(
                document: gql(GraphQL_.userInformation),
              ),
            );
    print(queryResult);
  }

  @override
  void initState() {
    _getAccessToken().then((value) => accessToken = value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //_getInfo();
    return SafeArea(
      child: Scaffold(
          appBar: createAppbar(
            context,
            title: 'My Info',
          ),
          body: Container(
            color: primaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: borderRadius(20.0, 20.0, 0.0, 0.0),
              ),
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 12),
                  _buildAvatar(),
                  const SizedBox(height: 12),
                  _buildBody(),
                ],
              ),
            ),
          )),
    );
  }

  //
  Widget _buildAvatar() {
    return Center(
      child: ClipOval(
        child: Image.asset(
          'assets/images/default_avt.png',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //
  Widget _buildBody() {
    print('accessToken: ' + accessToken);

    return Query(
      options: QueryOptions(
        document: gql(GraphQL_.userInformation),
        pollInterval: const Duration(seconds: 10),
      ),
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(child: CircularProgressIndicator(),);
        }

        /*if(result != null){

        }*/

        //print(result['userInformation']);
        return ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Text('$index');
            });
      },
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
