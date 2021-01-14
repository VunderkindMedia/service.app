import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/text/commentField.dart';

class RefusePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefusePageState();
}

class _RefusePageState extends State<RefusePage> {
  final ServiceController serviceController = Get.find();
  TextEditingController _commentController = TextEditingController();
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
        title: Text('Отказ клиента'),
      ),
      body: SafeArea(
          child: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                      ))
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          CommentField(controller: _commentController),
        ]))
      ])),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Obx(
        () => serviceController.refreshFabButtons(
          () async {
            if (_selectedValue.length > 0 &&
                _commentController.text.length > 0) {
              serviceController.fabsState.value = FabsState.Main;
              await serviceController.refuseService(
                  serviceController.service.value,
                  _selectedValue,
                  _commentController.text);
            } else {
              await Get.defaultDialog(
                  title: 'Ошибка!',
                  middleText:
                      'Выберите причину отказа и заполните комментарий!');
            }
          },
        ),
      ),
    );
  }
}
