import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:start/constants/constants.dart';
import 'package:start/model/timeline/collection.dart';
import 'package:start/model/timeline/timeline.dart';
import 'package:start/screens/home/user/widgets/custom_text_field.dart';
import 'package:start/store/user/my_timeline.dart';
import 'package:start/utils/toast.dart';
import 'package:start/widgets/app.dart';

class MyTimeLineScreen extends StatefulWidget {
  const MyTimeLineScreen({Key? key}) : super(key: key);
  static const String route = '/home/myTimeline';

  @override
  State<StatefulWidget> createState() => _MyTimeLineScreenState();
}

class _MyTimeLineScreenState extends State<MyTimeLineScreen> {
  //Store
  final MyTimelineStore _myTimelineStore = MyTimelineStore();

  //Controller
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  //
  late Future<List<MyTimeline>> timelineListFT;

  //datetime - picker
  DateTime selectedDate = DateTime.now();

  _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(
        () {
          selectedDate = picked;
          String year = picked.toLocal().year.toString();
          String month = (picked.toLocal().month.toString().length == 1)
              ? '0${picked.toLocal().month}'
              : picked.toLocal().month.toString();
          String day = (picked.toLocal().day.toString().length == 1)
              ? '0${picked.toLocal().day}'
              : picked.toLocal().day.toString();

          var date = "$year-$month-$day";
          print(date);
          controller.text = date;

          //Check distance between 2 date
          DateTime sDate =
              DateFormat("yyyy-MM-dd").parse(_startDateController.text);
          DateTime eDate =
              DateFormat("yyyy-MM-dd").parse(_endDateController.text);
          final difference = sDate.difference(eDate).inDays;
          print('Difference: ' + difference.abs().toString());
          if (difference.abs() > 30) {
            Toast.showSnackBar(context,
                message: 'Please input time range between 30 days!');
          } else {
            print(_startDateController.text);
            print(_endDateController.text);
            setState(
              () {
                timelineListFT = _myTimelineStore.getTimelineList(
                    startDate: _startDateController.text,
                    endDate: _endDateController.text);
              },
            );
          }
        },
      );
    }
  }

  @override
  void initState() {
    //1 month
    DateTime now = DateTime.now();
    DateTime newDate = DateTime(now.year, now.month - 1, now.day);
    _startDateController.text = DateFormat("yyyy-MM-dd").format(newDate);
    _endDateController.text = DateFormat("yyyy-MM-dd").format(now);

    //init TimelineList
    timelineListFT = _myTimelineStore.getTimelineList(
        startDate: _startDateController.text, endDate: _endDateController.text);
    //
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppbar(
        context,
        title: 'My Timeline',
      ),
      body: createBody(
        child: Observer(
          builder: (_) => Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                child: _buildChooseDate(),
              ),
              Expanded(
                child: FutureBuilder<List<MyTimeline>>(
                  future: timelineListFT,
                  builder: (context, AsyncSnapshot<List<MyTimeline>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('waiting');
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasData) {
                        _myTimelineStore.timelineList = snapshot.data ?? [];
                        if (_myTimelineStore.timelineList.isEmpty) {
                          return const Center(child: Text('Nothing'));
                        } else {
                          return SingleChildScrollView(
                            primary: true,
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _myTimelineStore.timelineList.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) {
                                return _buildItemTimeLine(
                                  index: index,
                                  timelineList: _myTimelineStore.timelineList,
                                );
                              },
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Center(child: Text('Error'));
                      }
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Pick date
  _buildChooseDate() {
    return Row(
      children: <Widget>[
        Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, _startDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _startDateController,
                title: 'From',
                isImportant: false,
                hintText: 'Choose',
                textInputType: TextInputType.datetime,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () => _selectDate(context, _endDateController),
            child: AbsorbPointer(
              child: CustomTextField(
                controller: _endDateController,
                title: 'To',
                isImportant: false,
                hintText: 'Choose',
                textInputType: TextInputType.datetime,
                suffixIcon: Icon(Icons.calendar_today_outlined,
                    color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///---------------------------------------------------------------------------
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
