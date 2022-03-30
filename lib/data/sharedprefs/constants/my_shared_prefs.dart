import '../shared_preference_helper.dart';

class MySharedPrefs {
  MySharedPrefs._();

  //EDIT KEY HERE
  static String isRemember = 'ISREMEMBER'; //already login //set bool

  //
  static String token = 'TOKEN'; //String
  static String token_type = 'TOKEN_TYPE';
  static String expires_in = 'expires_in';
  static String userId = 'userId';
  static String vfaEmail = 'vfaEmail';
  static String vfaAvatar = 'vfaAvatar';

// Get All SharedPreferences Test
  static Future<String> getAllSharedPrefs() async {
    try {
      SharedPreferencesHelper myPrefs = SharedPreferencesHelper();
      return '---------------------------------------------\n'
          'isRemember: ${(await myPrefs.get(MySharedPrefs.isRemember)).toString()}\n'
          'token_type:  ${(await myPrefs.get(MySharedPrefs.token_type)).toString()}\n'
          'token:  ${(await myPrefs.get(MySharedPrefs.token)).toString()}\n'
          'expires_in:  ${(await myPrefs.get(MySharedPrefs.expires_in)).toString()}\n'
          'userID:  ${(await myPrefs.get(MySharedPrefs.userId)).toString()}\n'
          'vfaEmail:  ${(await myPrefs.get(MySharedPrefs.vfaEmail)).toString()}\n'
          'vfaAvatar:  ${(await myPrefs.get(MySharedPrefs.vfaAvatar)).toString()}'
          '---------------------------------------------';
    } catch (e) {
      return 'Error at get All SharedPrefs: \n' + e.toString();
    }
  }
}
