import 'package:flutter/material.dart';
import 'package:start/data/network/apis/login_api.dart';
import 'package:start/data/sharedprefs/constants/my_shared_prefs.dart';
import 'package:start/utils/toast.dart';
import 'package:start/widgets/app.dart';
import '../../data/sharedprefs/shared_preference_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = '/login';

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //shared prefs
  SharedPreferencesHelper prefs = SharedPreferencesHelper();

  final LoginApi _loginApi = LoginApi();

  @override
  void initState() {
    emailController.text = 'sang@simple.com';
    passwordController.text = '12345678';
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(String vfaEmail, String password) async {
    print('I\'m in Login');
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.of(context).pop();
      Toast.showSnackBar(context, message: 'TextField Cannot Be Empty');
    } else {
      Map<String, dynamic>? mapData =
          await _loginApi.login(vfaEmail: vfaEmail, password: password);

      if (mapData!.isEmpty) {
        print('MapData is empty');
        Navigator.of(context).pop();
        Toast.showSnackBar(context, message: 'Login Fail!');
      } else {
        if (mapData['message'].toString() != 'null') {
          Navigator.of(context).pop();
          Toast.showSnackBar(context, message: mapData['message'].toString());
        } else if (mapData['login'].toString() != 'null') {
          prefs.set(MySharedPrefs.token_type,
              mapData['login']['token_type'].toString());
          prefs.set(MySharedPrefs.token, mapData['login']['token'].toString());
          prefs.set(MySharedPrefs.expires_in,
              mapData['login']['expires_in'].toString());
          prefs.set(MySharedPrefs.userId,
              mapData['login']['user']['userId'].toString());
          prefs.set(MySharedPrefs.vfaEmail,
              mapData['login']['user']['vfaEmail'].toString());
          prefs.set(MySharedPrefs.vfaAvatar,
              mapData['login']['user']['vfaAvatar'].toString());

          //Remember Login
          prefs.set(MySharedPrefs.isRemember, true);

          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (Route<dynamic> route) => false);
        }
      }
    }
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot Password'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.jpg',
                width: _size.width * 0.55,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 25),
              _buildEmailTextField(),
              const SizedBox(height: 10),
              _buildPasswordTextField(),
              const SizedBox(height: 5),
              _buildForgotPassword(onPressed: _forgotPassword),
              const SizedBox(height: 5),
              _buildSignInButton(context, onPressed: () async {
                showLoaderDialog(context);
                await _login(emailController.text, passwordController.text);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Row(
      children: <Widget>[
        Icon(
          const IconData(0xe491, fontFamily: 'MaterialIcons'),
          color: Colors.black.withOpacity(0.5),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            controller: emailController,
            minLines: 1,
            decoration: const InputDecoration(
              hintText: 'Please Enter User Email',
              focusedBorder: InputBorder.none,
            ),
            cursorColor: Colors.grey,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Row(
      children: <Widget>[
        Icon(Icons.lock_rounded, color: Colors.black.withOpacity(0.5)),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            controller: passwordController,
            minLines: 1,
            decoration: const InputDecoration(
              hintText: 'Please Enter Password',
              focusedBorder: InputBorder.none,
            ),
            cursorColor: Colors.grey,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword({Function()? onPressed}) {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: const Text('Forgot Password?',
            style: TextStyle(color: Colors.orange)),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context, {Function()? onPressed}) {
    var _size = MediaQuery.of(context).size;
    return SizedBox(
      width: _size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: Colors.redAccent.withOpacity(0.7),
          shape: const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: const Text('Sign In'),
      ),
    );
  }
}
