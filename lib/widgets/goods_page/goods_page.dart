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

    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        final GoodListArguments arguments = settings.arguments;
    
        var builder = (BuildContext _) => Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: goods.length,
                  itemBuilder: (context, i) {
                    return GoodItem(good: goods[i]);
                  },
                ))
              ],
            );
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class GoodListArguments {
  final Good parentGood;

  GoodListArguments(this.parentGood);
}

class GoodItem extends StatelessWidget {
  final Good good;

  GoodItem({Key key, @required this.good}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GoodList(parentGood: good)));
      },
      child: ListTile(
        leading: good.isGroup ? Icon(Icons.folder_open) : null,
        title: Text('${good.name}'),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
