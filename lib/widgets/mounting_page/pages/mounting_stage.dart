import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/get/controllers/sync_controller.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/mounting_image.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/models/stage.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/text/commentField.dart';

class MountStage extends StatefulWidget {
  MountStage({this.mounting, this.mountingStage, this.stage, this.pickedFile});

  final Mounting mounting;
  final MountingStage mountingStage;
  final Stage stage;
  final PickedFile pickedFile;

  @override
  _MountStageState createState() => _MountStageState();
}

class _MountStageState extends State<MountStage> {
  final MountingController mountingController = Get.find();
  final typingFlag = false.obs;
  final loadingFlag = false.obs;
  final picker = ImagePicker();
  TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    commentController =
        TextEditingController(text: widget.mountingStage.comment);

    return Scaffold(
      appBar: AppBar(
        title: Text('Этап'),
        actions: [
          Obx(
            () => loadingFlag.value
                ? IconButton(
                    padding: EdgeInsets.all(16.0),
                    icon: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.black)),
                    tooltip: 'Выгрузка',
                    autofocus: true,
                    color: Colors.black,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: Icon(Icons.library_add),
                          onPressed: () async {
                            PickedFile image = await picker.getImage(
                              source: ImageSource.gallery,
                              imageQuality: 60,
                            );
                            if (image != null) {
                              loadingFlag.toggle();
                              String imagePath = image.path;
                              await ImageGallerySaver.saveFile(imagePath);
                              await mountingController.addMountingImage(
                                  widget.mountingStage, imagePath);
                              loadingFlag.toggle();
                            }
                            print('galerry image');
                          }),
                      IconButton(
                          icon: Icon(Icons.camera),
                          onPressed: () async {
                            PickedFile image = await picker.getImage(
                              source: ImageSource.camera,
                              imageQuality: 60,
                            );
                            if (image != null) {
                              loadingFlag.toggle();
                              String imagePath = image.path;
                              await ImageGallerySaver.saveFile(imagePath);
                              await mountingController.addMountingImage(
                                  widget.mountingStage, imagePath);
                              loadingFlag.toggle();
                            }
                            print('camera image');
                          })
                    ],
                  ),
          )
        ],
      ),
      body: SafeArea(
        child: ModalProgressHUD(
            inAsyncCall: loadingFlag.value,
            child: ImagesList(
              header: Card(
                child: ListTile(
                  title: Text(
                    '${widget.stage.name}',
                    style: kCardTitleStyle,
                  ),
                  subtitle: TextField(
                    textAlign: TextAlign.left,
                    controller: commentController,
                    maxLines: 4,
                    maxLength: 255,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Введите комментарий...'),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () async {
                      await mountingController.editMountingStage(
                          widget.mountingStage, commentController.text);

                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
              stageId: widget.stage.id,
            )),
      ),
    );
  }
}

class ImagesList extends StatelessWidget {
  final MountingController mountingController = Get.find();
  final Widget header;
  final String stageId;

  ImagesList({@required this.header, @required this.stageId});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: mountingController.mountingImages.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return header;

            var image = mountingController.mountingImages[i - 1];
            if (image.stageId == stageId)
              return ImageWidget(imageModel: image);
            else
              return SizedBox();
          }),
    );
  }
}

class ImageWidget extends StatelessWidget {
  final SyncController syncController = Get.find();
  final MountingController mountingController = Get.find();
  final AccountController accountController = Get.find();
  final MountingImage imageModel;
  final int cacheWidth;
  final int cacheHeight;

  ImageWidget({this.imageModel, this.cacheWidth, this.cacheHeight});

  Widget getImageCardWidget(BuildContext context, MountingImage imageModel) {
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
      var url = syncController.getFileImageUrl("mounting", imageModel.fileId);
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
          await mountingController.deleteMountingImage(imageModel);
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
                await mountingController.deleteMountingImage(imageModel);
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
