import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/widgets/mountings_page/mountings_page.dart';
import 'package:service_app/widgets/services_page/services_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AccountController accountController = Get.find();
  final SyncController syncController = Get.find();
  final DbService dbService = Get.find();

  final TextEditingController inputController = TextEditingController();

  bool authState = false;

  void changeAuthState(bool currState) {
    setState(() {
      authState = currState;
    });
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    changeAuthState(true);
    var accountInfo = await accountController.login();

    if (accountInfo != null) {
      await syncController.initController();
      await Future.forEach(accountInfo.userRole, (role) async {
        /* TODO: change to constant */
        switch (role) {
          case "ServiceMember":
            await syncController.initServiceCatalogs();
            await Get.offAll(ServicesPage());
            break;
          case "MountingMember":
            await syncController.initMountingCatalogs();
            await Get.offAll(MountingsPage());
            break;
        }
      });
    } else {
      FocusScope.of(context).previousFocus();
    }
    changeAuthState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Авторизация'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: authState,
          progressIndicator: Center(
            child: Container(
              width: 250.0,
              height: 250.0,
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10.0),
                    Text(
                        'Выполняется авторизация и загрузка справочной информации!'),
                  ],
                ),
              ),
            ),
          ),
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Container(
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.white.withOpacity(0.6),
                      child: TextField(
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: 'Логин'),
                          onChanged: (text) {
                            accountController.username.value = text;
                          }),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      color: Colors.white.withOpacity(0.6),
                      child: TextField(
                        controller: inputController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(hintText: 'Пароль'),
                        onChanged: (text) {
                          accountController.password.value = text;
                        },
                        onSubmitted: (_) async {
                          await _login();
                        },
                      ),
                    ),
                    SizedBox(height: 36.0),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: RaisedButton(
                          onPressed: () async {
                            await _login();
                          },
                          color: kMainColor,
                          textColor: kTextLightColor,
                          child: Text('Войти')),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
