import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    void _signIn(String email, String password) {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('TextField Cannot Be Empty'),
          ),
        );
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/home', (Route<dynamic> route) => false);
      }
    }

    void _forgotPassword() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Forgot Password'),
        ),
      );
    }

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
                onPressed: () =>
                    _signIn(emailController.text, passwordController.text),
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
