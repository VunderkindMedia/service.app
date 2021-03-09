import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/widgets/buttons/action_button.dart';
import 'package:service_app/widgets/text/commentField.dart';
import 'package:service_app/widgets/text/cardRow.dart';

class ReschedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReschedulePageState();
}

class _ReschedulePageState extends State<ReschedulePage> {
  final ServiceController serviceController = Get.find();
  final loadingFlag = false.obs;

  DateTime _selectedDate;
  TextEditingController _commentController = TextEditingController();

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          MainActionButton(
            label: 'Подтвердить перенос даты',
            color: kFabActionColor,
            icon: Icons.create_outlined,
            onPressed: () async {
              if (_selectedDate != null && _commentController.text.length > 0) {
                loadingFlag.toggle();
                await serviceController.rescheduleService(
                    serviceController.service.value,
                    _selectedDate,
                    _commentController.text);
                loadingFlag.toggle();
                Get.back();
              } else {
                await Get.defaultDialog(
                    title: 'Ошибка!',
                    middleText:
                        'Введите причину переноса заявки и выберите новую дату!');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Obx(
        () => ModalProgressHUD(
          inAsyncCall: loadingFlag.value,
          child: CustomScrollView(slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CardRow(
                      leading: Text('Дата переноса:',
                          style: TextStyle(fontSize: 16.0)),
                      tailing: Text(
                          _selectedDate != null
                              ? formattedDate(_selectedDate)
                              : 'Нажмите для выбора',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
                CommentField(controller: _commentController),
              ]),
            ),
          ]),
        ),
      )),
    );
  }
}
