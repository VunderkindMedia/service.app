import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:service_app/get/controllers/service_controller.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';
import 'package:service_app/constants/app_colors.dart';
import 'images_list.dart';

class AttachmentsPage extends StatefulWidget {
  @override
  _AttachmentsPageState createState() => _AttachmentsPageState();
}

class _AttachmentsPageState extends State<AttachmentsPage> {
  final ServiceController serviceController = Get.find();
  final loadingFlag = false.obs;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            'Вложения заявки (${serviceController.serviceImages.length})')),
      ),
      body: SafeArea(
        child: Obx(
          () => ModalProgressHUD(
            inAsyncCall: loadingFlag.value,
            child: ImagesList(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => loadingFlag.value
            ? FloatingActionButton.extended(
                onPressed: null,
                icon: Icon(Icons.archive),
                label: Text('Сохранение'),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingButton(
                    label: 'Вложение',
                    heroTag: 'lfab',
                    alignment: Alignment.bottomLeft,
                    onPressed: () async {
                      PickedFile image = await picker.getImage(
                        source: ImageSource.gallery,
                        imageQuality: 60,
                      );
                      if (image != null) {
                        loadingFlag.toggle();
                        String imagePath = image.path;
                        await ImageGallerySaver.saveFile(imagePath);
                        await serviceController.addServiceImage(
                            DateTime.now().microsecondsSinceEpoch.toString() +
                                '.png',
                            imagePath);
                        loadingFlag.toggle();
                      }
                      print('galerry image');
                    },
                    iconData: Icons.library_add,
                    extended: true,
                    color: kFabActionColor.withOpacity(0.8),
                  ),
                  FloatingButton(
                    label: 'Камера',
                    heroTag: 'rfab',
                    alignment: Alignment.bottomRight,
                    onPressed: () async {
                      PickedFile image = await picker.getImage(
                        source: ImageSource.camera,
                        imageQuality: 60,
                      );
                      if (image != null) {
                        loadingFlag.toggle();
                        String imagePath = image.path;
                        await ImageGallerySaver.saveFile(imagePath);
                        await serviceController.addServiceImage(
                            DateTime.now().microsecondsSinceEpoch.toString() +
                                '.png',
                            imagePath);
                        loadingFlag.toggle();
                      }
                      print('camera image');
                    },
                    iconData: Icons.camera_alt,
                    extended: true,
                    color: kFabActionColor.withOpacity(0.8),
                  )
                ],
              ),
      ),
    );
  }
}
