import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/account_controller.dart';

class LoginPage extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Логин'),
                  onChanged: (text) {
                    accountController.username.value = text;
                  }),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: 'Пароль'),
                  onChanged: (text) {
                    accountController.password.value = text;
                  }),
              SizedBox(
                height: 36.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: RaisedButton(
                    onPressed: accountController.login, color: Theme.of(context).primaryColor, textColor: Colors.white, child: Text('Войти')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
