import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:start/data/network/apis/timeline_api.dart';
import 'package:start/model/timeline/timeline.dart';

part 'my_timeline.g.dart';

class MyTimelineStore = _MyTimelineStore with _$MyTimelineStore;

abstract class _MyTimelineStore with Store {
  _MyTimelineStore();

  final TimelineApi _timelineApi = TimelineApi();

  @observable
  List<MyTimeline> timelineList = [];

  @action
  Future<List<MyTimeline>> getTimelineList(
      {required String startDate, required String endDate}) async {
    timelineList = await _timelineApi.getTimelineList(
        startDate: startDate, endDate: endDate);
    return timelineList;
  }

  @action
  Future<void> createActivity(BuildContext context,
      {required String activityTypes}) async {
    await _timelineApi.createActivity(context, activityTypes: activityTypes);
  }
}
