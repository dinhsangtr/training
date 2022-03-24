import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_shared_prefs.dart';

class GraphQLConfig {

  static HttpLink httpLink = HttpLink(
    'http://54.255.247.6:3001/graphql',
  );

  static ValueNotifier<GraphQLClient> graphInit() {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(),
      ),
    );
    return client;
  }

  static ValueNotifier<GraphQLClient> query(String fullToken) {
    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: HttpLink(
          'http://54.255.247.6:3001/graphql',
          defaultHeaders: <String, String>{
            'authorization': fullToken,
          }
        ),
        cache: GraphQLCache(),
      ),
    );
    return client;
  }

}


