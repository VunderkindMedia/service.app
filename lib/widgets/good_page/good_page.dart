import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/widgets/text/cardRow.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/service_status.dart';

class GoodPage extends StatefulWidget {
  final int goodId;

  GoodPage({@required this.goodId});

  @override
  _GoodPageState createState() => _GoodPageState();
}

class _GoodPageState extends State<GoodPage> {
  final ServiceController serviceController = Get.find();

  double _eval(good, price, count) {
    var mprice = good.minPrice / 100;
    var val = price / 100 * double.parse(count);

    if (mprice > 0 && mprice > val) val = mprice.toDouble();
    return val;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.fabsState.value = FabsState.GoodAdding;
    });
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      serviceController.fabsState.value = FabsState.Main;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _countController = TextEditingController(text: '1');
    TextEditingController _constructionController = TextEditingController();
    var sum = 0.0.obs;

    return Builder(builder: (BuildContext context) {
      var good =
          serviceController.goods.firstWhere((g) => g.id == widget.goodId);
      var goodPrice = serviceController.goodPrices.firstWhere(
          (gp) => gp.goodId == good.externalId,
          orElse: () => GoodPrice(-1, 0));
      var parsedImg = good.image;
      parsedImg = parsedImg.replaceAll(String.fromCharCode(10), '');
      parsedImg = parsedImg.replaceAll(String.fromCharCode(13), '');
      var bytes = base64.decode(parsedImg);

      sum.value = _eval(good, goodPrice.price, _countController.text);

      return Scaffold(
        appBar: AppBar(
          title: Text('Добавление услуги'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            Obx(() => serviceController.refreshFabButtons(() async {
                  await serviceController.addServiceGood(
                      good,
                      _constructionController.text,
                      goodPrice,
                      double.parse(_countController.text));
                  serviceController.fabsState.value = FabsState.Main;
                })),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ExpansionTile(
                          initiallyExpanded: good.image.isNotEmpty,
                          title: Text(
                            '${good.name}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: good.image.isNotEmpty
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Image.memory(bytes))
                                  : Padding(
                                      padding: const EdgeInsets.all(50.0),
                                      child: Icon(Icons.image_not_supported),
                                    ),
                            )
                          ],
                        ),
                        SizedBox(height: 20.0),
                        CardRow(
                          leading: Text(
                            'Артикул:',
                            style: kCardSubtitleStyle,
                          ),
                          tailing: Text(
                            '${good.article.isNotEmpty ? good.article : '-'}',
                            style: kCardSubtitleStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                        CardRow(
                          leading: Text(
                            'Цена:',
                            style: kCardSubtitleStyle,
                          ),
                          tailing: MoneyPlate(
                            amount: goodPrice.price / 100,
                            style: kCardSubtitleStyle,
                          ),
                        ),
                        good.minPrice > 0
                            ? CardRow(
                                leading: Text(
                                  'Минимальная стоимость:',
                                  style: kCardSubtitleStyle,
                                ),
                                tailing: MoneyPlate(
                                  amount: good.minPrice / 100,
                                  style: kCardSubtitleStyle,
                                ),
                              )
                            : SizedBox.shrink(),
                        SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  Card(
                    child: Column(
                      children: [
                        CardRow(
                          leading: Text(
                            'Конструкция:',
                            style: kCardSubtitleStyle,
                          ),
                          tailing: TextField(
                            decoration:
                                InputDecoration(hintText: 'Не обязательно'),
                            style: kCardSubtitleStyle,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _constructionController,
                          ),
                        ),
                        CardRow(
                          leading: Text(
                            'Количество:',
                            style: kCardSubtitleStyle,
                          ),
                          tailing: TextField(
                            showCursor: false,
                            style: kCardSubtitleStyle,
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            textAlignVertical: TextAlignVertical.center,
                            controller: _countController,
                            onChanged: (value) {
                              sum.value = _eval(
                                  good, goodPrice.price, _countController.text);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 16.0),
                          child: CardRow(
                            leading: Text(
                              'Итого:',
                              style: kCardTitleStyle,
                            ),
                            tailing: Obx(() => MoneyPlate(
                                  amount: sum.value,
                                  style: kCardSubtitleStyle,
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 80.0)
                ]),
              )
            ],
          ),
        ),
      );
    });
  }
}
