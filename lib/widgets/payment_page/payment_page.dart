import 'package:flutter/services.dart';
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
  double paymentSumm;
  var minPayment = 0.0.obs;
  var discountSumm = 0.0.obs;
  var totalSumm = 0.0.obs;

  String _selectedPayment;
  List<S2Choice<String>> _paymentOptions = [
    S2Choice<String>(value: PaymentTypes.Cash, title: PaymentTypes.Cash),
    S2Choice<String>(value: PaymentTypes.Card, title: PaymentTypes.Card),
  ];
  String _selectedDecision;
  List<S2Choice<String>> _decision = [
    S2Choice<String>(value: ClientDecision.Agree, title: ClientDecision.Agree),
    S2Choice<String>(value: ClientDecision.Think, title: ClientDecision.Think),
    S2Choice<String>(
        value: ClientDecision.Refuse, title: ClientDecision.Refuse),
  ];
  int _selectedDiscount = 0;
  List<S2Choice<int>> _discounts = [
    S2Choice<int>(value: 0, title: 'Без скидки'),
    S2Choice<int>(value: 5, title: 'Скидка 5%'),
    S2Choice<int>(value: 7, title: 'Скидка 7%'),
  ];
  DateTime _selectedDate;
  TextEditingController _commentController = TextEditingController();
  TextEditingController _paymentController = TextEditingController();

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

    _eval();

    if (summTO2 == 0)
      _selectedDecision = ClientDecision.Refuse;
    else
      _selectedDecision = ClientDecision.Think;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fabsState.value = FabsState.Main;
    });
  }

  void _eval() {
    var discountTO1 = 0.0;
    var discountTO2 = summTO2 * _selectedDiscount / 100;

    var s1 = ((summTO1 - discountTO1) / 10).ceilToDouble() * 10;
    var s2 = ((summTO2 - discountTO2) / 10).ceilToDouble() * 10;

    discountTO1 = summTO1 - s1;
    discountTO2 = summTO2 - s2;

    minPayment.value = s1;
    discountSumm.value = discountTO1 + discountTO2;
    totalSumm.value = s1 + s2;
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
              Card(
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(
                    'Информация по заказу',
                    style: kCardTitleStyle,
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        discountSumm.value > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Text(
                                      'Скидка:',
                                      style: kCardSubtitleStyle,
                                    ),
                                    Obx(() => MoneyPlate(
                                          amount: discountSumm.value,
                                          style: kCardSubtitleStyle,
                                        ))
                                  ])
                            : SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Итого:',
                              style: kCardSubtitleStyle,
                            ),
                            Obx(() => MoneyPlate(
                                  amount: totalSumm.value,
                                  style: kCardSubtitleStyle,
                                ))
                          ],
                        ),
                      ],
                    ),
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
                    SmartSelect<int>.single(
                      placeholder: '-',
                      modalType: S2ModalType.bottomSheet,
                      title: 'Скидка',
                      value: _selectedDiscount,
                      choiceItems: _discounts,
                      onChange: (state) => setState(() {
                        _selectedDiscount = state.value;
                        _eval();
                      }),
                      modalHeaderStyle: S2ModalHeaderStyle(
                        textStyle: TextStyle(),
                        backgroundColor: kDarkMainColor,
                      ),
                    ),
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
                            onChange: (state) =>
                                setState(() => _selectedDecision = state.value),
                            modalHeaderStyle: S2ModalHeaderStyle(
                              textStyle: TextStyle(),
                              backgroundColor: kDarkMainColor,
                            ),
                          ),
                          _selectedDecision == ClientDecision.Agree ||
                                  _selectedDecision == ClientDecision.Think
                              ? GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: CardRow(
                                      leading: Text(
                                        'Дата ТО-2',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      tailing: Text(
                                        _selectedDate != null
                                            ? formattedDate(_selectedDate)
                                            : 'Не выбрана',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ),
                                  onTap: () => _selectDate(context),
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
                      placeholder: 'Не выбран',
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
                    CardRow(
                      leading: Text(
                        'Минимальная сумма платежа',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      tailing: MoneyPlate(
                        amount: minPayment.value,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    CardRow(
                      leading: Text(
                        'Сумма оплаты',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      tailing: TextFormField(
                        style: kCardSubtitleStyle,
                        textAlign: TextAlign.end,
                        controller: _paymentController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 80.0)
            ]),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Obx(() => serviceController.refreshFabButtons(() async {
                if (_paymentController.text.isEmpty) {
                  await Get.defaultDialog(
                      title: 'Ошибка!', middleText: 'Введите сумму оплаты!');
                  return;
                }
                if (_selectedPayment == null) {
                  await Get.defaultDialog(
                      title: 'Ошибка!', middleText: 'Укажите способ оплаты!');
                  return;
                }
                var paymentSumm = double.parse(_paymentController.text);
                if (paymentSumm < minPayment.value) {
                  await Get.defaultDialog(
                      title: 'Ошибка!',
                      middleText:
                          'Минимальаня сумма платежа не соответствует введенной!');
                  return;
                }
                if (_selectedDecision != ClientDecision.Refuse &&
                    _selectedDate == null) {
                  await Get.defaultDialog(
                      title: 'Ошибка!', middleText: 'Выберите дату для ТО-2!');
                  return;
                }
                if (_selectedDecision == ClientDecision.Refuse &&
                    _commentController.text.isEmpty) {
                  await Get.defaultDialog(
                      title: 'Ошибка!',
                      middleText: 'Заполните комментарий к отказу от ТО-2!');
                  return;
                }

                serviceController.fabsState.value = FabsState.Main;
                await serviceController.finishService(
                    serviceController.service.value,
                    _selectedDecision,
                    _selectedDate,
                    _commentController.text,
                    _selectedPayment,
                    totalSumm.toInt() * 100,
                    int.parse(_paymentController.text) * 100,
                    discountSumm.value.toInt() * 100);
              })),
    );
  }
}
