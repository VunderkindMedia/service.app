import 'package:flutter/material.dart';
import 'package:service_app/services_page/services_page.dart';

class LoginPage extends StatelessWidget {
  void _handleSubmitTapped(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ServicesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Логин'),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: 'Пароль'),
              ),
              SizedBox(
                height: 36.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: RaisedButton(
                    onPressed: () {
                      _handleSubmitTapped(context);
                    },
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Text('Войти')
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}