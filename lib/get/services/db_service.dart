import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService extends GetxService {
  static const SERVICES_TABLE_NAME = "services";
  static const SERVICE_GOODS_NAME = "service_goods";
  static const BRANDS_TABLE_NAME = "brands";
  static const GOODS_TABLE_NAME = "goods";
  static const GOOD_PRICES_TABLE_NAME = "good_prices";

  static Database _database;

  Future<DbService> init() async {
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
    String path = join(databasesPath, 'app.db');

    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $SERVICES_TABLE_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'createdAt DATETIME,'
          'updatedAt DATETIME,'
          'externalId TEXT,'
          'number TEXT,'
          'deleteMark BOOLEAN,'
          'status TEXT,'
          'dateStart DATETIME,'
          'dateEnd DATETIME,'
          'cityId TEXT,'
          'brandId TEXT,'
          'customer TEXT,'
          'customerAddress TEXT,'
          'floor TEXT,'
          'intercom BOOLEAN,'
          'thermalImager BOOLEAN,'
          'phone TEXT,'
          'comment TEXT,'
          'userId TEXT,'
          'paymentType TEXT,'
          'customerDecision TEXT,'
          'refuseReason TEXT,'
          'userComment TEXT,'
          'dateStartNext DATETIME,'
          'dateEndNext DATETIME,'
          'sumTotal INTEGER,'
          'sumPayment INTEGER,'
          'sumDiscount INTEGER'
          ')');
      await db.execute('CREATE TABLE $SERVICE_GOODS_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'workType TEXT,'
          'serviceId INTEGER,'
          'construction TEXT,'
          'goodId TEXT,'
          'price INTEGER,'
          'qty INTEGER,'
          'sum INTEGER'
          ')');
      await db.execute('CREATE TABLE $BRANDS_TABLE_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'externalId TEXT,'
          'name TEXT,'
          'code TEXT,'
          'deleteMark BOOLEAN'
          ')');
      await db.execute('CREATE TABLE $GOODS_TABLE_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'externalId TEXT,'
          'name TEXT,'
          'parentId TEXT,'
          'code TEXT,'
          'deleteMark BOOLEAN,'
          'article TEXT,'
          'isGroup BOOLEAN,'
          'minPrice INTEGER,'
          'image TEXT'
          ')');
      await db.execute('CREATE TABLE $GOOD_PRICES_TABLE_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'period DATETIME,'
          'goodId TEXT,'
          'cityId TEXT,'
          'brandId TEXT,'
          'name BOOLEAN,'
          'price INTEGER'
          ')');
    });
    print('$runtimeType ready!');
    return this;
  }

  Future<void> saveServices(List<Service> services) async {
    await _database.transaction((txn) async {
      services.forEach((service) async {
        await txn.insert(SERVICES_TABLE_NAME, service.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted service ${service.number}');
      });
    });
  }

  Future<List<Service>> getServices() async {
    final List<Map<String, dynamic>> maps = await _database.query(SERVICES_TABLE_NAME);
    return List.generate(maps.length, (i) => Service.fromMap(maps[i]));
  }

  Future<void> saveBrands(List<Brand> brands) async {
    await _database.transaction((txn) async {
      brands.forEach((brand) async {
        await txn.insert(BRANDS_TABLE_NAME, brand.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted brand ${brand.name}');
      });
    });
  }

  Future<List<Brand>> getBrands() async {
    final List<Map<String, dynamic>> maps = await _database.query(BRANDS_TABLE_NAME);
    return List.generate(maps.length, (i) => Brand.fromMap(maps[i]));
  }

  Future<void> saveGoods(List<Good> goods) async {
    await _database.transaction((txn) async {
      goods.forEach((good) async {
        await txn.insert(GOODS_TABLE_NAME, good.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted good ${good.name}');
      });
    });
  }

  Future<List<Good>> getGoods() async {
    final List<Map<String, dynamic>> maps = await _database.query(GOODS_TABLE_NAME);
    return List.generate(maps.length, (i) => Good.fromMap(maps[i]));
  }

  Future<void> saveGoodPrices(List<GoodPrice> goodPrices) async {
    await _database.transaction((txn) async {
      goodPrices.forEach((goodPrice) async {
        await txn.insert(GOOD_PRICES_TABLE_NAME, goodPrice.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted goodPrice ${goodPrice.name}');
      });
    });
  }

  Future<List<GoodPrice>> getGoodPrices() async {
    final List<Map<String, dynamic>> maps = await _database.query(GOOD_PRICES_TABLE_NAME);
    return List.generate(maps.length, (i) => GoodPrice.fromMap(maps[i]));
  }

  @override
  void onClose() {
    super.onClose();
    _database.close();
  }
}
