import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';

class RefusePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefusePageState();
}

class _RefusePageState extends State<RefusePage> {
  final ServiceController serviceController = Get.find();
  String _selectedValue = '';
  List<String> _reasons = [
    'Высокая цена',
    'Не берет трубку',
    'Отремонтировали сами',
    'Ушел к конкуренту',
    'Нет потребности'
  ];

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fabsState.value = FabsState.Main;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Форма отказа'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Причина отказа',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  ...this._reasons.map((reason) => GestureDetector(
                        onTap: () {
                          setState(() {
                            this._selectedValue = reason;
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: reason,
                              groupValue: this._selectedValue,
                              onChanged: (String value) {
                                setState(() {
                                  this._selectedValue = value;
                                });
                              },
                            ),
                            Text(reason),
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  Text('Коментарий',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  TextField(
                    maxLines: null,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Пару слов о причине отказа'),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(null)),
    );
  }
}
