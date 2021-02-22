import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/widgets/good_page/good_page.dart';
import 'package:service_app/models/service_status.dart';

class GoodsPage extends StatefulWidget {
  @override
  _GoodsPageState createState() => _GoodsPageState();
}

class _GoodsPageState extends State<GoodsPage> {
  final ServiceController serviceController = Get.find();

  @override
  void initState() {
    super.initState();
    serviceController.refreshGoods();
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      serviceController.search.value = '';
      serviceController.filteredGoods.clear();
      serviceController.fabsState.value = FabsState.Main;
    });
  }

  void _clearSearch() {
    serviceController.isSarching.value = !serviceController.isSarching.value;

    if (!serviceController.isSarching.value) {
      serviceController.search.value = '';
      serviceController.filteredGoods.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => !serviceController.isSarching.value
            ? Text('Выберите услугу')
            : TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search, color: kTextLightColor),
                    hintText: 'Поиск',
                    hintStyle: kSearchBarTextStyle),
                style: kSearchBarTextStyle,
                autofocus: true,
                onChanged: (value) {
                  serviceController.search.value = value;
                  serviceController.refreshGoods();
                },
                onEditingComplete: () {},
              )),
        actions: [
          Obx(
            () => IconButton(
              icon: !serviceController.isSarching.value
                  ? Icon(Icons.search)
                  : Icon(Icons.cancel),
              onPressed: _clearSearch,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => serviceController.isSarching.value
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  itemCount: serviceController.filteredGoods.length,
                  itemBuilder: (context, i) =>
                      GoodItem(good: serviceController.filteredGoods[i]),
                )
              : Builder(
                  builder: (BuildContext context) => GoodList(parentGood: null),
                ),
        ),
      ),
    );
  }
}

class GoodList extends StatelessWidget {
  final ServiceController serviceController = Get.find();
  final Good parentGood;

  GoodList({Key key, @required this.parentGood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ref');
    var goods = serviceController.getListGoodsByParent(parentGood);
    var hasBack = parentGood != null;

    return Container(
      child: Column(
        children: [
          if (hasBack)
            Container(
              child: GoodItem(good: parentGood, isBack: true),
            ),
          Expanded(
            child: Navigator(
              onGenerateRoute: (RouteSettings settings) {
                var builder = (_) => ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: goods.length,
                      itemBuilder: (context, i) {
                        return GoodItem(good: goods[i]);
                      },
                    );
                return MaterialPageRoute(builder: builder, settings: settings);
              },
            ),
          )
        ],
      ),
    );
  }
}

class GoodItem extends StatelessWidget {
  final ServiceController serviceController = Get.find();
  final Good good;
  final bool isBack;

  GoodItem({Key key, @required this.good, this.isBack = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (isBack) {
            Navigator.of(context).pop();
          } else if (good.isGroup) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GoodList(parentGood: good)));
          } else {
            Get.to(GoodPage(goodId: good.id));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isBack
                  ? Icon(Icons.arrow_back_ios, size: 16)
                  : SizedBox(width: 16),
              Container(
                margin: EdgeInsets.only(left: 8, right: 16),
                child: good.isGroup
                    ? Icon(Icons.folder_open, size: 24)
                    : Container(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
              ),
              Expanded(
                  child: Text(
                '${good.name}',
                style: TextStyle(fontSize: 16.0, color: kTextLightColor),
              )),
              if (!isBack)
                Container(
                    margin: EdgeInsets.only(left: 16),
                    child: Icon(Icons.arrow_forward_ios, size: 16))
            ],
          ),
        ));
  }
}
