import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  _signIn() {}

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    TextEditingController? emailController = TextEditingController();
    TextEditingController? passwordController = TextEditingController();

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
              Row(
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
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Icon(Icons.lock_rounded,
                      color: Colors.black.withOpacity(0.5)),
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
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text('Forgot Password?',
                      style: TextStyle(color: Colors.orange)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Forgot Password'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: _size.width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.redAccent.withOpacity(0.7),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  },
                  child: const Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
