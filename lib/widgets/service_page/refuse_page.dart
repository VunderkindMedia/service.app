import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/widgets/text/commentField.dart';

class RefusePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RefusePageState();
}

class _RefusePageState extends State<RefusePage> {
  final ServiceController serviceController = Get.find();
  final loadingFlag = false.obs;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отказ клиента'),
        actions: [
          IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                if (_selectedValue.length > 0 &&
                    _commentController.text.length > 0) {
                  loadingFlag.toggle();
                  await serviceController.refuseService(
                      serviceController.service.value,
                      _selectedValue,
                      _commentController.text);
                  loadingFlag.toggle();
                  Get.back();
                } else {
                  await Get.defaultDialog(
                      title: 'Ошибка!',
                      middleText:
                          'Выберите причину отказа и заполните комментарий!');
                }
              })
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: loadingFlag.value,
            child: CustomScrollView(slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Причина отказа',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
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
                ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
