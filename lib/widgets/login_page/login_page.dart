import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:service_app/redux/account/actions.dart';
import 'package:service_app/redux/root_reducer.dart';

class LoginPage extends StatelessWidget {
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
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
                        username = text;
                      }
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(hintText: 'Пароль'),
                      onChanged: (text) {
                        password = text;
                      }
                  ),
                  SizedBox(
                    height: 36.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: RaisedButton(
                        onPressed: () {
                          store.dispatch(loginAction(context, username, password));
                        },
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text('Войти')),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}