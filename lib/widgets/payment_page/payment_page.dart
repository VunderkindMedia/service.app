import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:smart_select/smart_select.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';
import 'package:service_app/widgets/text/cardRow.dart';
import 'package:service_app/widgets/text/commentField.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final ServiceController serviceController = Get.find();
  double summTO1 = 0.0;
  double summTO2 = 0.0;
  double discountSumm;
  double paymentSumm;

  String _selectedPayment;
  List<S2Choice<String>> _paymentOptions = [
    S2Choice<String>(value: 'Наличные', title: 'Наличные'),
    S2Choice<String>(value: 'Безнал Сбербанк', title: 'Безнал Сбербанк'),
    S2Choice<String>(value: 'Безнал ВТБ', title: 'Безнал ВТБ'),
  ];
  String _selectedDecision;
  List<S2Choice<String>> _decision = [
    S2Choice<String>(value: 'Согласен', title: 'Согласен'),
    S2Choice<String>(value: 'Подумаю', title: 'Подумаю'),
    S2Choice<String>(value: 'Отказ', title: 'Отказ'),
  ];
  DateTime _selectedDate;
  TextEditingController _commentController = TextEditingController();

  String formattedDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return _selectedDate != null ? formatter.format(date) : 'Не выбрана';
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  void initState() {
    super.initState();

    serviceController.serviceGoods
        .where((sg) => sg.workType == WorkTypes.TO1)
        .toList()
        .forEach((element) {
      summTO1 += element.sum / 10000;
    });
    serviceController.serviceGoods
        .where((sg) => sg.workType == WorkTypes.TO2)
        .toList()
        .forEach((element) {
      summTO2 += element.sum / 10000;
    });

    if (summTO2 == 0)
      _selectedDecision = 'Отказ';
    else
      _selectedDecision = 'Подумаю';
  }

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
        title: Text('Завершение работ'),
      ),
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Card(
                  child: ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      'Информация по заказу',
                      style: kCardTitleStyle,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Итого:',
                          style: kCardSubtitleStyle,
                        ),
                        MoneyPlate(
                          amount: summTO1 + summTO2,
                          style: kCardSubtitleStyle,
                        )
                      ],
                    ),
                    children: [
                      CardRow(
                        leading: Text('Сумма ТО-1:'),
                        tailing: MoneyPlate(amount: summTO1),
                      ),
                      CardRow(
                        leading: Text('Сумма ТО-2:'),
                        tailing: MoneyPlate(amount: summTO2),
                      ),
                      SizedBox(height: 20.0)
                    ],
                  ),
                ),
                summTO2 > 0
                    ? Card(
                        child: ExpansionTile(
                          title: Text(
                            'Данные ТО-2',
                            style: kCardTitleStyle,
                          ),
                          children: [
                            SmartSelect<String>.single(
                              modalType: S2ModalType.bottomSheet,
                              title: 'Решение клиента',
                              value: _selectedDecision,
                              choiceItems: _decision,
                              onChange: (state) => setState(
                                  () => _selectedDecision = state.value),
                              modalHeaderStyle: S2ModalHeaderStyle(
                                textStyle: TextStyle(),
                                backgroundColor: kDarkMainColor,
                              ),
                            ),
                            _selectedDecision == 'Согласен' ||
                                    _selectedDecision == 'Подумаю'
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Дата ТО-2:'),
                                          Container(
                                            child: Text(
                                                formattedDate(_selectedDate)),
                                            margin: EdgeInsets.only(right: 16),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              _selectDate(context);
                                            },
                                            color: Colors.blue,
                                            textColor: Colors.white,
                                            child: Text('Выбрать дату'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            CommentField(controller: _commentController),
                          ],
                        ),
                      )
                    : SizedBox(),
                Card(
                  child: ExpansionTile(
                    title: Text(
                      'Оплата заказа',
                      style: kCardTitleStyle,
                    ),
                    children: [
                      SmartSelect<String>.single(
                        modalType: S2ModalType.bottomSheet,
                        title: 'Способ оплаты',
                        value: _selectedPayment,
                        choiceItems: _paymentOptions,
                        onChange: (state) =>
                            setState(() => _selectedPayment = state.value),
                        modalHeaderStyle: S2ModalHeaderStyle(
                          textStyle: TextStyle(),
                          backgroundColor: kDarkMainColor,
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ]),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(null)),
    );
  }
}
