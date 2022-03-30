import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/data/network/constants/constants.dart';
import 'package:start/model/timeline/timeline.dart';
import 'package:start/utils/toast.dart';
import 'package:start/widgets/custom_dialog.dart';

import '../graphql_client.dart';

class TimelineApi {
  TimelineApi();

  //Create Activity
  Future<void> createActivity(BuildContext context, {required String activityTypes}) async {
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

  // MyTimeLine Screen
  Future<List<MyTimeline>> getTimelineList(
      {required String startDate, required String endDate}) async {
    await Future.delayed(const Duration(seconds: 1));
    QueryResult queryResult = await GraphQLConfig.client().value.query(
      QueryOptions(
        document: gql(GraphQLConstants.myTimeLine),
        variables: {
          "input": {
            "startDate": startDate,
            "endDate": endDate,
          }
        },
      ),
    );
    if (queryResult.data!['myTimeLine']['error']['requestResolved'] == false) {
      print(queryResult.data!['myTimeLine']['error']['message']);
      return [];
    } else {
      //
      List<dynamic> responseList = queryResult.data!['myTimeLine']['response'];

      print(responseList.length);
      if (responseList.isEmpty) {
        return [];
      } else {
        List<MyTimeline> timelineList = [];
        for (int i = 0; i < responseList.length; i++) {
          timelineList.add(MyTimeline.fromJson(responseList[i]));
        }
        return timelineList;
      }
    }
  }

}