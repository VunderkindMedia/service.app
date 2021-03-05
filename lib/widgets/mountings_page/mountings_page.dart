import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_range_picker/date_range_picker.dart' as drp;
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/get/controllers/mountings_controller.dart';
import 'package:service_app/get/controllers/notifications_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/push_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/mounting_page/mounting_page.dart';
import 'package:service_app/widgets/mountings_page/mountings_list_tile.dart';
import 'package:service_app/widgets/side-menu/side-menu.dart';

class MountingsPage extends StatefulWidget {
  @override
  _MountingsPageState createState() => _MountingsPageState();
}

class _MountingsPageState extends State<MountingsPage> {
  final SyncController syncController = Get.find();
  final MountingsController mountingsController =
      Get.put(MountingsController());
  final MountingController mountingController = Get.put(MountingController());
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

    selectedDateStart = mountingsController.selectedDateStart.value;
    selectedDateEnd = mountingsController.selectedDateEnd.value;

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        await mountingsController.sync(false);
        await notificationsController.ref();

        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        await mountingsController.sync(false);
        await notificationsController.ref();
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        await mountingsController.sync(false);
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

  Widget _buildRow(Mounting mounting) {
    var brand = mountingsController.brands.firstWhere(
        (brand) => brand.externalId == mounting.brandId,
        orElse: () => null);

    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () async {
          await mountingController.init(mounting.id);
          await mountingController.onInit();
          await Get.to(MountingPage(mountingId: mounting.id));
        },
        child: MountingListTile(
          mounting: mounting,
          brand: brand,
        ),
      ),
    );
  }

  Future<void> _clearSearch() async {
    if (mountingsController.searchString.length == 0)
      mountingsController.isSearching.value =
          !mountingsController.isSearching.value;
    else {
      mountingsController.searchString = "";
      searchController.clear();
    }

    await mountingsController.sync(false);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !mountingsController.isSearching.value
            ? Row(children: [
                Text("Монтажи"),
                Obx(() => Text(" (${mountingsController.mountingCount})")),
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
                  mountingsController.searchString = value;
                },
                onEditingComplete: () =>
                    mountingsController.ref(selectedDateStart, selectedDateEnd),
              ),
        actions: [
          IconButton(
            icon: !mountingsController.isSearching.value
                ? Icon(Icons.search)
                : Icon(Icons.cancel),
            onPressed: _clearSearch,
          ),
          IconButton(
            icon: Icon(Icons.tune_rounded),
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

                mountingsController.selectedDateStart.value = selectedDateStart;
                mountingsController.selectedDateEnd.value = selectedDateEnd;

                if (mountingsController.isSearching.value) {
                  await _clearSearch();
                } else {
                  await mountingsController.sync(false, true);
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
                        onPressed: () => mountingsController.sync(true),
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
                      itemCount: mountingsController.filteredMountings.length,
                      itemBuilder: (context, i) {
                        return _buildRow(
                            mountingsController.filteredMountings[i]);
                      },
                    ),
                  ),
                ),
              ],
            ),
            onRefresh: () async {
              await mountingsController.sync(true);
              await notificationsController.ref();
            }),
      ),
    );
  }
}
