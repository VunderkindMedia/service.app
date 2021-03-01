import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_range_picker/date_range_picker.dart' as drp;
import 'package:service_app/get/controllers/notifications_controller.dart';
import 'package:service_app/models/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/service_page/service_page.dart';
import 'package:service_app/widgets/services_page/services_list_tile.dart';
import 'package:service_app/widgets/side-menu/side-menu.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final SyncController syncController = Get.put(SyncController());
  final ServicesController servicesController = Get.put(ServicesController());
  final ServiceController serviceController = Get.put(ServiceController());
  final NotificationsController notificationsController =
      Get.put(NotificationsController());

  final TextEditingController searchController = TextEditingController();

  final GlobalKey<RefreshIndicatorState> _refKey =
      GlobalKey<RefreshIndicatorState>();

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  DateTime selectedDateStart;
  DateTime selectedDateEnd;
  bool showFAB = true;

  @override
  void initState() {
    super.initState();

    selectedDateStart = servicesController.selectedDateStart.value;
    selectedDateEnd = servicesController.selectedDateEnd.value;

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        await servicesController.sync(false);
        await notificationsController.ref();

        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        await servicesController.sync(false);
        await notificationsController.ref();
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        await servicesController.sync(false);
        await notificationsController.ref();

        notificationsController.openNotification(
          PushNotification(
              '', message['data']['item'], message['data']['guid']),
        );

        print("onResume: $message");
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  Widget _buildRow(Service service) {
    var brand = servicesController.brands.firstWhere(
        (brand) => brand.externalId == service.brandId,
        orElse: () => null);

    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          await serviceController.init(service.id);
          await serviceController.onInit();
          await Get.to(ServicePage(serviceId: service.id));
        },
        child: ServiceListTile(
          service: service,
          brand: brand,
        ),
      ),
    );
  }

  Future<void> _clearSearch() async {
    if (servicesController.searchString.length == 0)
      servicesController.isSearching.value =
          !servicesController.isSearching.value;
    else {
      servicesController.searchString = "";
      searchController.clear();
    }

    await servicesController.sync(false);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !servicesController.isSearching.value
            ? Row(children: [
                Text("Заявки"),
                Obx(() => Text(" (${servicesController.servicesCount})")),
              ])
            : TextField(
                controller: searchController,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: kTextLightColor),
                  hintText: 'Поиск',
                  hintStyle: kSearchBarTextStyle,
                ),
                style: kSearchBarTextStyle,
                autofocus: true,
                onChanged: (value) {
                  servicesController.searchString = value;
                },
                onEditingComplete: () =>
                    servicesController.ref(selectedDateStart, selectedDateEnd),
              ),
        actions: [
          IconButton(
            icon: !servicesController.isSearching.value
                ? Icon(Icons.search)
                : Icon(Icons.cancel),
            onPressed: _clearSearch,
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final List<DateTime> picked = await drp.showDatePicker(
                  context: context,
                  initialFirstDate: selectedDateStart,
                  initialLastDate: selectedDateEnd,
                  firstDate: DateTime.now().add(Duration(days: -30)),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                  locale: Locale('ru'));

              if (picked != null) {
                selectedDateStart = picked[0];
                selectedDateEnd = picked.length == 2 ? picked[1] : picked[0];

                servicesController.selectedDateStart.value = selectedDateStart;
                servicesController.selectedDateEnd.value = selectedDateEnd;

                if (servicesController.isSearching.value) {
                  await _clearSearch();
                } else {
                  await servicesController.ref(
                      selectedDateStart, selectedDateEnd);
                  await servicesController.sync(false, true);
                }
              }
            },
          ),
        ],
      ),
      drawer: SideMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: showFAB,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => syncController.needSync
                    ? FloatingActionButton.extended(
                        onPressed: () => servicesController.sync(true),
                        label: Row(
                          children: [
                            Icon(
                              Icons.sync_problem,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              'Синхронизировать',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
            color: kAppHeaderColor,
            backgroundColor: kBackgroundLight,
            key: _refKey,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: servicesController.filteredServices.length,
                      itemBuilder: (context, i) {
                        return _buildRow(
                            servicesController.filteredServices[i]);
                      },
                    ),
                  ),
                ),
              ],
            ),
            onRefresh: () async {
              await servicesController.sync(true);
              await notificationsController.ref();
            }),
      ),
    );
  }
}
