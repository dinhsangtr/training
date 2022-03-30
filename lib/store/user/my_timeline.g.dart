// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_timeline.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyTimelineStore on _MyTimelineStore, Store {
  final _$timelineListAtom = Atom(name: '_MyTimelineStore.timelineList');

  @override
  List<MyTimeline> get timelineList {
    _$timelineListAtom.reportRead();
    return super.timelineList;
  }

  @override
  set timelineList(List<MyTimeline> value) {
    _$timelineListAtom.reportWrite(value, super.timelineList, () {
      super.timelineList = value;
    });
  }

  final _$getTimelineListAsyncAction =
      AsyncAction('_MyTimelineStore.getTimelineList');

  @override
  Future<List<MyTimeline>> getTimelineList(
      {required String startDate, required String endDate}) {
    return _$getTimelineListAsyncAction.run(
        () => super.getTimelineList(startDate: startDate, endDate: endDate));
  }

  @override
  String toString() {
    return '''
timelineList: ${timelineList}
    ''';
  }
}
