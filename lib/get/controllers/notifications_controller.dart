import 'package:get/get.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/services/db_service.dart';
import 'package:service_app/models/push_notifications.dart';
import 'package:service_app/widgets/service_page/service_page.dart';

class NotificationsController extends GetxController {
  final ServiceController serviceController = Get.find();
  var hasNew = false.obs;

  RxList<PushNotification> notifications = <PushNotification>[].obs;

  DbService _dbService;

  @override
  void onInit() {
    super.onInit();

    _dbService = Get.find();

    notifications.listen((v) {
      if (notifications.length > 0)
        hasNew.value =
            notifications.indexWhere((element) => element.isNew) != -1;
    });
  }

  @override
  void dispose() {
    super.dispose();

    hasNew.value = false;
    notifications.clear();
  }

  void openNotification(PushNotification push) async {
    switch (push.messageType) {
      case "doc.service":
        {
          var service = await _dbService.getServiceByGUID(push.guid);

          if (push.id.isNotEmpty) await markIsNew(push, false);
          await serviceController.init(service.id);
          await serviceController.onInit();
          await Get.to(ServicePage(serviceId: service.id));
        }
    }
  }

  Future<void> markIsNew(PushNotification push, bool isNew) async {
    push.isNew = isNew;
    await _dbService.savePush([push]);
    await ref();
  }

  Future<void> ref() async {
    var dbNotifications = await _dbService.getPush(50);
    notifications.assignAll(dbNotifications);
  }
}
