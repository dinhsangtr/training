import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/constants/constants.dart';
import 'package:start/data/network/constants/constants.dart';
import 'package:start/data/network/graphql_client.dart';
import 'package:start/model/timeline/collection.dart';
import 'package:start/model/timeline/timeline.dart';
import 'package:start/widgets/app.dart';

class MyTimeLineScreen extends StatefulWidget {
  const MyTimeLineScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyTimeLineScreenState();
}

class _MyTimeLineScreenState extends State<MyTimeLineScreen> {
  late Future<List<MyTimeline>> timelineListFT;
  late List<MyTimeline> timelineList;
  Map<String, bool> map = {};

  ScrollController _scrollController = ScrollController();

  //
  Future<List<MyTimeline>> getTimeline() async {
    await Future.delayed(const Duration(seconds: 1));
    QueryResult queryResult = await GraphQLConfig.client().value.query(
          QueryOptions(
            document: gql(GraphQLConstants.myTimeLine),
            variables: {
              "input": {"startDate": "2022-03-01", "endDate": "2022-03-31"}
            },
          ),
        );
    if (queryResult.data!['myTimeLine']['error']['requestResolved'] == false) {
      print(queryResult.data!['myTimeLine']['error']['message']);
      return [];
    } else {
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

  @override
  void initState() {
    timelineListFT = getTimeline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getTimeline();
    return Scaffold(
      appBar: createAppbar(
        context,
        title: 'My Timeline',
      ),
      body: FutureBuilder<List<MyTimeline>>(
        future: timelineListFT,
        builder: (context, AsyncSnapshot<List<MyTimeline>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return Container(
                color: Colors.grey.withOpacity(0.2),
                child: const Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              timelineList = snapshot.data ?? [];
              if (timelineList.isEmpty) {
                return const Center(child: Text('Nothing'));
              } else {
                // for (int i = 0; i < timelineList.length; i++) {
                //   map.addAll({'isExpanded${i.toString()}': false});
                // }
                // print(map);

                return Container(
                  color: primaryColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius(20.0, 20.0, 0.0, 0.0),
                    ),
                    child: SingleChildScrollView(
                      primary: true,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                          ),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: timelineList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return _buildItemTimeLine(
                                index: index,
                                timelineList: timelineList,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            }
          }
          return Container();
        },
      ),
    );
  }

  bool isExpanded = false;

  _buildItemTimeLine(
      {required int index, required List<MyTimeline> timelineList}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          // map.update(('isExpanded${index.toString()}'),
          //     (value) => !(map['isExpanded${index.toString()}'] ?? false));
        });
        //print(map['isExpanded${index.toString()}']);
      },
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 70,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Container(
                      color: primaryColor,
                      width: 70,
                      height: 70,
                      child: const Icon(Icons.calendar_today_sharp,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(timelineList[index].groupDate!,
                          style: const TextStyle(fontSize: 18)),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: primaryColor,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          isExpanded
              ? ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, i) {
                    return const Divider();
                  },
                  itemBuilder: (context, i) {
                    return _buildItemCollection(
                        col: timelineList[index].collections, index: i);
                  },
                  itemCount: timelineList[index].collections!.length)
              : const SizedBox(height: 0, width: 0)
        ],
      ),
    );
  }

  _buildItemCollection({required List? col, required int index}) {
    //print(col![index]);
    Collection collection = Collection.fromJson(col![index]);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 40.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(collection.activityTypes ?? 'TYPE'),
                    Text(collection.activityDescription ?? 'Description',
                        style: const TextStyle(color: Colors.grey))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//

}
