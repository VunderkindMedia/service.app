import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/good.dart';

class GoodsPage extends StatelessWidget {
  final ServicesController servicesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Форма выбора номенклатуры'),
      ),
      body: SafeArea(
          child: Builder(
        builder: (BuildContext context) => GoodList(parentGood: null),
      )),
    );
  }
}

class GoodList extends StatelessWidget {
  final ServicesController servicesController = Get.find();

  final Good parentGood;

  GoodList({Key key, @required this.parentGood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var goods = servicesController.getChildrenGoodsByParent(parentGood);
    var hasBack = parentGood != null;

    if (hasBack) {
      print('${parentGood.name}');
    } else {
      print('no parent');
    }

    return Navigator(
      key: Key(parentGood == null ? 'no' : parentGood.externalId),
      onGenerateRoute: (RouteSettings settings) {
        var builder = (BuildContext _) => ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: hasBack ? goods.length + 1 : goods.length,
          itemBuilder: (context, i) {
            if (hasBack && i == 0) {
              return GoodItem(good: parentGood, isBack: true);
            }
            return GoodItem(good: goods[hasBack ? i - 1 : i]);
          },
        );
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class GoodItem extends StatelessWidget {
  final Good good;
  final bool isBack;

  GoodItem({Key key, @required this.good, this.isBack = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isBack) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoodList(parentGood: good)));
        }
      },
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isBack) Container(
                margin: EdgeInsets.only(right: 16),
                child: Icon(Icons.arrow_back_ios, size: 16)
            ),
            Container(
              margin: EdgeInsets.only(right: 16),
              child: good.isGroup ? Icon(Icons.folder_open, size: 24) : SizedBox(height: 24, width: 24),
            ),
            Expanded(child: Text('${good.name}')),
            if (!isBack) Container(
                margin: EdgeInsets.only(left: 16),
                child: Icon(Icons.arrow_forward_ios, size: 16)
            )
          ],
        ),
      )
    );
  }
}
