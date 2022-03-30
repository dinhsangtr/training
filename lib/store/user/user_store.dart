import 'package:mobx/mobx.dart';
import 'package:start/data/network/apis/user_api.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';
import 'package:start/data/sharedprefs/shared_preference_helper.dart';
import 'package:start/model/timeline/timeline.dart';
import 'package:start/model/user/uservfa.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  _UserStore();

  @observable
  List<MyTimeline> timelineList = [];

  @observable
  bool isLoggedIn = false;

  @observable
  UserVfa userVfa = UserVfa();

  @action
  getStatusRemember() async {
    SharedPreferencesHelper prefs = SharedPreferencesHelper();
    isLoggedIn = await prefs.get(MySharedPrefs.isRemember) ?? false;
    //print('Remember Login: ' + isRememberLogin.toString());
  }

  final UserApi _userApi = UserApi();

  @action
  Future<UserVfa> getUserVfa() async {
    return await _userApi.getUser();
  }


}
