import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoggingIn = false;

  _login() async {
    setState(() {
      isLoggingIn = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'Invalid-email':
          message = 'the email you enterd is invalied';
          break;
        case 'user-disabled':
          message = 'your user is disabled';
          break;
        case 'user-not':
          message = 'user not found';
          break;
        case 'wrong-password':
          message = 'your password is wrong';
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('log in failed'),
              content: Text(message.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
              ],
            );
          });
    } finally {
      setState(() {
        isLoggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Restaurants',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 32),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Log in',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 32),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
              ),
            ),
            if (!isLoggingIn)
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        child: Text('Log in'))),
              ),
            SizedBox(
              height: 10,
            ),
            if (isLoggingIn)
              Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }
}
