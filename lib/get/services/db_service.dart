import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

class DbService extends GetxService {
  Future<DbService> init() async {
    print('$runtimeType delays 1 sec');
    await Future.delayed(const Duration(milliseconds: 1000));
    print('$runtimeType ready!');
    return this;
  }
}