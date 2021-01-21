import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:service_app/models/brand.dart';
import 'package:service_app/models/good.dart';
import 'package:service_app/models/good_price.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/models/service_good.dart';
import 'package:service_app/models/service_image.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService extends GetxService {
  static const SERVICES_TABLE_NAME = "services";
  static const SERVICE_GOODS_NAME = "service_goods";
  static const SERVICE_IMAGES_NAME = "service_images";
  static const BRANDS_TABLE_NAME = "brands";
  static const GOODS_TABLE_NAME = "goods";
  static const GOOD_PRICES_TABLE_NAME = "good_prices";

  static Database _database;

  Future<DbService> init() async {
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
    String path = join(databasesPath, 'app.db');

    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE $SERVICES_TABLE_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'state TEXT,'
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
          'lat TEXT,'
          'lon TEXT,'
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
          'sumDiscount INTEGER,'
          'export BOOLEAN'
          ')');
      await db.execute('CREATE TABLE $SERVICE_GOODS_NAME '
          '('
          'id TEXT,'
          'workType TEXT,'
          'serviceId INTEGER,'
          'construction TEXT,'
          'goodId INTEGER,'
          'price INTEGER,'
          'qty INTEGER,'
          'sum INTEGER,'
          'export BOOLEAN,'
          'UNIQUE(id, serviceId)'
          ')');
      await db.execute('CREATE TABLE $SERVICE_IMAGES_NAME '
          '('
          'id TEXT,'
          'serviceId INTEGER,'
          'fileId INTEGER,'
          'fileName TEXT,'
          'local TEXT,'
          'export BOOLEAN,'
          'UNIQUE(id, serviceId)'
          ')');
      await db.execute('CREATE TABLE $BRANDS_TABLE_NAME '
          '('
          'id INTEGER PRIMARY KEY,'
          'externalId TEXT,'
          'name TEXT,'
          'code TEXT,'
          'deleteMark BOOLEAN,'
          'brandColor TEXT'
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
          'name TEXT,'
          'price INTEGER,'
          'UNIQUE(goodId, cityId, brandId)'
          ')');
    });
    print('$runtimeType ready!');
    return this;
  }

  Future<void> disposeTables() async {
    await _database.delete('$SERVICES_TABLE_NAME');
    await _database.delete('$SERVICE_IMAGES_NAME');
    await _database.delete('$SERVICE_GOODS_NAME');
    await _database.delete('$BRANDS_TABLE_NAME');
    await _database.delete('$GOODS_TABLE_NAME');
    await _database.delete('$GOOD_PRICES_TABLE_NAME');
  }

  Future<void> saveServices(List<Service> services) async {
    await _database.transaction((txn) async {
      services.forEach((service) async {
        await txn.insert(SERVICES_TABLE_NAME, service.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        service.serviceGoods?.forEach((serviceGood) async {
          await txn.insert(SERVICE_GOODS_NAME, serviceGood.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });
        service.serviceImages?.forEach((serviceImage) async {
          await txn.insert(SERVICE_IMAGES_NAME, serviceImage.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        });
      });
    });
  }

  Future<List<Service>> getServices(
      String userId, DateTime dStart, DateTime dEnd) async {
    String _query =
        "userId = ? AND (dateStart >= ? AND dateEnd <= ?) AND deleteMark == 0";

    final List<Map<String, dynamic>> maps = await _database.query(
      SERVICES_TABLE_NAME,
      where: _query,
      whereArgs: [userId, dStart.toString(), dEnd.toString()],
      orderBy: "dateStart",
    );
    return List.generate(maps.length, (i) => Service.fromMap(maps[i]));
  }

  Future<Service> getServiceById(int id) async {
    String _query = "id = ?";

    final List<Map<String, dynamic>> maps = await _database.query(
      SERVICES_TABLE_NAME,
      where: _query,
      whereArgs: [id],
    );
    return List.generate(maps.length, (i) => Service.fromMap(maps[i]))[0];
  }

  Future<List<Service>> getServicesBySearch(
      String userId, String search) async {
    String _search = '%' + search + '%';
    String _query =
        "userId = ? AND (number LIKE ? OR customerAddress LIKE ?) AND deleteMark == 0";

    final List<Map<String, dynamic>> maps = await _database.query(
      SERVICES_TABLE_NAME,
      where: _query,
      whereArgs: [userId, _search, _search],
      orderBy: "dateStart DESC",
    );
    return List.generate(maps.length, (i) => Service.fromMap(maps[i]));
  }

  Future<void> saveBrands(List<Brand> brands) async {
    await _database.transaction((txn) async {
      brands.forEach((brand) async {
        await txn.insert(BRANDS_TABLE_NAME, brand.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted brand ${brand.name}');
      });
    });
  }

  Future<List<Brand>> getBrands() async {
    final List<Map<String, dynamic>> maps =
        await _database.query(BRANDS_TABLE_NAME);
    return List.generate(maps.length, (i) => Brand.fromMap(maps[i]));
  }

  Future<void> saveGoods(List<Good> goods) async {
    await _database.transaction((txn) async {
      goods.forEach((good) async {
        await txn.insert(GOODS_TABLE_NAME, good.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted good ${good.name}');
      });
    });
  }

  Future<List<Good>> getGoods(Service service) async {
    var maps = await _database.rawQuery(
        'SELECT goods.* ' +
            'FROM goods ' +
            'LEFT JOIN good_prices ' +
            'ON goods.externalId = good_prices.goodId ' +
            'WHERE (goods.deleteMark = 0 AND good_prices.brandId = ?) OR isGroup = 1',
        [service.brandId]);
    return List.generate(maps.length, (i) => Good.fromMap(maps[i]));
  }

  Future<void> saveGoodPrices(List<GoodPrice> goodPrices) async {
    await _database.transaction((txn) async {
      goodPrices.forEach((goodPrice) async {
        await txn.insert(GOOD_PRICES_TABLE_NAME, goodPrice.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
        // print('inserted goodPrice ${goodPrice.name}');
      });
    });
  }

  Future<List<GoodPrice>> getGoodPrices(Service service) async {
    String _query = 'cityId = ? AND brandId = ?';
    var maps = await _database.query(GOOD_PRICES_TABLE_NAME,
        where: _query, whereArgs: [service.cityId, service.brandId]);
    return List.generate(maps.length, (i) => GoodPrice.fromMap(maps[i]));
  }

  Future<void> saveServiceGoods(List<ServiceGood> serviceGood) async {
    await _database.transaction((txn) async {
      serviceGood.forEach((sg) async {
        await txn.insert(SERVICE_GOODS_NAME, sg.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    });
  }

  Future<void> saveServiceImages(List<ServiceImage> serviceImage) async {
    await _database.transaction((txn) async {
      serviceImage.forEach((si) async {
        await txn.insert(SERVICE_IMAGES_NAME, si.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
    });
  }

  Future<void> addServiceGood(ServiceGood serviceGood) async {
    await _database.transaction((txn) async {
      await txn.insert(SERVICE_GOODS_NAME, serviceGood.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> deleteServiceGood(ServiceGood serviceGood) async {
    await _database.transaction((txn) async {
      await txn.delete(SERVICE_GOODS_NAME,
          where: 'id = ?', whereArgs: [serviceGood.id]);
    });
  }

  Future<void> addServiceImage(ServiceImage serviceImage) async {
    await _database.transaction((txn) async {
      await txn.insert(SERVICE_IMAGES_NAME, serviceImage.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<void> deleteServiceImage(ServiceImage serviceImage) async {
    await _database.transaction((txn) async {
      await txn.delete(SERVICE_IMAGES_NAME,
          where: 'id = ?', whereArgs: [serviceImage.id]);
    });
  }

  Future<List<ServiceGood>> getServiceGoods(int serviceId) async {
    var _query = "serviceId = ?";

    final List<Map<String, dynamic>> maps = await _database
        .query(SERVICE_GOODS_NAME, where: _query, whereArgs: [serviceId]);
    return List.generate(maps.length, (i) => ServiceGood.fromMap(maps[i]));
  }

  Future<List<ServiceImage>> getServiceImages(int serviceId) async {
    final List<Map<String, dynamic>> maps = await _database.query(
        SERVICE_IMAGES_NAME,
        where: "serviceId = ?",
        whereArgs: [serviceId]);
    return List.generate(maps.length, (i) => ServiceImage.fromMap(maps[i]));
  }

  Future<List<Service>> getExportServices(String userId) async {
    String _query = "userId = ? AND deleteMark == 0 AND export == 1";
    final List<Map<String, dynamic>> maps = await _database
        .query(SERVICES_TABLE_NAME, where: _query, whereArgs: [userId]);
    return List.generate(maps.length, (i) => Service.fromMap(maps[i]));
  }

  Future<List<ServiceGood>> getExportServiceGoods() async {
    String _query = "export == 1";
    final List<Map<String, dynamic>> maps =
        await _database.query(SERVICE_GOODS_NAME, where: _query);
    return List.generate(maps.length, (i) => ServiceGood.fromMap(maps[i]));
  }

  Future<List<ServiceImage>> getExportServiceImages() async {
    String _query = "export == 1";
    final List<Map<String, dynamic>> maps =
        await _database.query(SERVICE_IMAGES_NAME, where: _query);
    return List.generate(maps.length, (i) => ServiceImage.fromMap(maps[i]));
  }

  @override
  void onClose() {
    super.onClose();
    _database.close();
  }
}
