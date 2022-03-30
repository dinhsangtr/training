import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/data/network/constants/constants.dart';
import '../graphql_client.dart';

class LoginApi {
  LoginApi();

  Future<Map<String, dynamic>?> login(
      {required String vfaEmail, required String password}) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      QueryResult queryResult = await GraphQLConfig.client().value.mutate(
            MutationOptions(
              document: gql(GraphQLConstants.signIn),
              variables: {
                "input": {
                  "vfaEmail": vfaEmail,
                  "password": password,
                }
              },
            ),
          );
      print('Data: ' + queryResult.data.toString());
      if (queryResult.exception != null) {
        List<GraphQLError> graphqlErrors = queryResult.exception!.graphqlErrors;
        print(graphqlErrors.first.message.toString());
        return {'message': graphqlErrors.first.message.toString()};
      } else if (queryResult.data != null) {
        return queryResult.data;
      }
      return {};
    } catch (e) {
      print('Login Error: ' + e.toString());
      return {};
    }
  }
}
