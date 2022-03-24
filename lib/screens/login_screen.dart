import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:start/utils/toast.dart';
import '../graphql_.dart';
import '../utils/my_shared_prefs.dart';
import '../utils/graphql_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //shared prefs
  MySharedPrefs prefs = MySharedPrefs();

  @override
  void initState() {
    emailController.text = 'bbb@bbb.bbb';
    passwordController.text = '12345678';
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(String vfaEmail, String password) async {
    print('I\'m in Login');
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Toast.showSnackBar(context, message: 'TextField Cannot Be Empty');
    } else {
      await GraphQLConfig.graphInit().value.mutate(
            MutationOptions(
              document: gql(GraphQL_.signIn),
              variables: {
                "input": {
                  "vfaEmail": vfaEmail,
                  "password": password,
                }
              },
              onError: (OperationException? error) {
                List<GraphQLError> graphqlErrors = error!.graphqlErrors;
                print('Login Error: ' + graphqlErrors.first.message.toString());
                Toast.showSnackBar(context,
                    message: graphqlErrors.first.message.toString());
              },
              onCompleted: (dynamic data) {
                print('Data: ' + (data.toString() != 'null' ? 'Oke' : 'Empty'));

                if (data != null) {
                  //Save data
                  prefs.set(MySharedPrefs.token_type,
                      data['login']['token_type'].toString());
                  prefs.set(
                      MySharedPrefs.token, data['login']['token'].toString());
                  prefs.set(MySharedPrefs.expires_in,
                      data['login']['expires_in'].toString());
                  prefs.set(MySharedPrefs.userId,
                      data['login']['user']['userId'].toString());
                  prefs.set(MySharedPrefs.vfaEmail,
                      data['login']['user']['vfaEmail'].toString());
                  prefs.set(MySharedPrefs.vfaAvatar,
                      data['login']['user']['vfaAvatar'].toString());

                  //Remember Login
                  prefs.set(MySharedPrefs.isRemember, true);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                }
              },
            ),
          );
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
              _buildSignInButton(
                context,
                onPressed: () async => await _signIn(
                    emailController.text, passwordController.text),
              ),
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

