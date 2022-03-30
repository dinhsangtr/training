import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/data/network/constants/constants.dart';
import 'package:start/model/user/uservfa.dart';
import '../graphql_client.dart';

class UserApi {
  UserApi();

  // Info Screen
  Future<UserVfa> getUser() async {
    QueryResult queryResult = await GraphQLConfig.client().value.query(
          QueryOptions(
            document: gql(GraphQLConstants.userInformation),
          ),
        );
    if (queryResult.data!['userInformation'].toString() == 'null') {
      return UserVfa();
    } else {
      Map<String, dynamic> mapData =
          queryResult.data!['userInformation']['response'];
      print(mapData);
      UserVfa userVfa = UserVfa.fromJson(mapData);
      return userVfa;
    }
  }

}
