import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/models/good.dart';

class GoodPage extends StatelessWidget {
  final ServiceController serviceController = Get.find();
  final int goodId;

  GoodPage({Key key, @required this.goodId}) : super(key: key);

  Widget _buildKeyValue(Widget w1, w2) {
    return Container(
      padding: EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          w1,
          Expanded(
              child: Container(
            margin: EdgeInsets.only(left: 8),
            child: w2,
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      var good = serviceController.goods.firstWhere((g) => g.id == goodId);
      var goodPrice = serviceController.goodPrices.firstWhere((gp) => gp.goodId == good.externalId, orElse: () => null);

      return Scaffold(
        appBar: AppBar(
          title: Text('${good.name}'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildKeyValue(
                          Text('Артикул:'),
                          Text(
                            good.article,
                            style: TextStyle(color: Colors.grey),
                          )),
                      _buildKeyValue(
                          Text('Наименование:'),
                          Text(
                            good.name,
                            style: TextStyle(color: Colors.grey),
                          )),
                      _buildKeyValue(
                          Text('Цена:'),
                          Text(
                            goodPrice.toString(),
                            style: TextStyle(color: Colors.grey),
                          )),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text('Выбрать'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
