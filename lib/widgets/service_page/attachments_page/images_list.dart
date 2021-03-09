import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/models/service_image.dart';

class ImagesList extends StatelessWidget {
  final ServiceController serviceController = Get.find();

  ImagesList();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: serviceController.serviceImages.length,
          itemBuilder: (context, i) {
            return ImageWidget(imageModel: serviceController.serviceImages[i]);
          }),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final SyncController syncController = Get.find();
  final ServiceController serviceController = Get.find();
  final AccountController accountController = Get.find();
  final ServiceImage imageModel;
  final int cacheWidth;
  final int cacheHeight;

  ImageWidget({this.imageModel, this.cacheWidth, this.cacheHeight});

  Widget getImageCardWidget(BuildContext context, ServiceImage imageModel) {
    File imageFile = File(imageModel.local);

    if (imageModel.local.isNotEmpty && imageFile.existsSync()) {
      var imgFile = FileImage(imageFile);
      return Image.file(
        imageFile,
        fit: BoxFit.fitWidth,
        filterQuality: FilterQuality.low,
        scale: imgFile.scale,
      );
    } else {
      var url = syncController.getFileImageUrl("service", imageModel.fileId);
      var accessToken = accountController.token;
      return CachedNetworkImage(
        imageUrl: url,
        httpHeaders: {'authorization': 'Bearer $accessToken'},
        placeholder: (context, url) => Container(
            height: MediaQuery.of(context).size.width,
            child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.fitWidth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageCardWidget = getImageCardWidget(context, imageModel);

    if (imageModel.export) {
      return GestureDetector(
        onLongPress: () async {
          await serviceController.deleteServiceImage(imageModel);
        },
        child: OverlayImage(
          image: imageCardWidget,
          infoWidget: CircularProgressIndicator(),
          textWidget: Text('Изображение выгружается'),
        ),
      );
    } else {
      return GestureDetector(
        onLongPress: () async {
          await Get.defaultDialog(
              title: 'Удаление вложения',
              middleText:
                  'Вы действительно хотите удалить вложение на сервере?',
              textConfirm: 'Да',
              confirmTextColor: Colors.white,
              onConfirm: () async {
                await serviceController.deleteServiceImage(imageModel);
                Navigator.of(context).pop();
              },
              textCancel: 'Нет',
              onCancel: () {
                return;
              });
        },
        child: Card(child: imageCardWidget),
      );
    }
  }
}

class OverlayImage extends StatelessWidget {
  final Widget infoWidget;
  final Widget textWidget;

  const OverlayImage(
      {Key key, @required this.image, this.infoWidget, this.textWidget})
      : super(key: key);

  final Widget image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          image,
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 80),
            child: Center(
              child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      infoWidget,
                      SizedBox(height: 10.0),
                      textWidget
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
        fit: StackFit.passthrough,
      ),
    );
  }
}
