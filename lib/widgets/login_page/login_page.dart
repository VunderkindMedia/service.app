import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/account_controller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AccountController accountController = Get.put(AccountController());

  bool authState = false;

  void changeAuthState(bool currState) {
    setState(() {
      authState = currState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: authState,
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Container(
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.handyman_rounded,
                    size: 100,
                    color: kSecondColor,
                  ),
                  SizedBox(height: 40),
                  TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: 'Логин'),
                      onChanged: (text) {
                        accountController.username.value = text;
                      }),
                  SizedBox(height: 24.0),
                  TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: 'Пароль'),
                      onChanged: (text) {
                        accountController.password.value = text;
                      }),
                  SizedBox(height: 36.0),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: RaisedButton(
                        onPressed: () async {
                          changeAuthState(true);
                          await accountController.login();
                          changeAuthState(false);
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text('Войти')),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
