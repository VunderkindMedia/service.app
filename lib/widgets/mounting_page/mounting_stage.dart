import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/get/controllers/mounting_controller.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/models/mounting_stage.dart';
import 'package:service_app/models/stage.dart';
import 'package:service_app/widgets/buttons/fab_button.dart';
import 'package:service_app/constants/app_colors.dart';
import 'package:service_app/widgets/text/commentField.dart';

class MountStage extends StatefulWidget {
  MountStage({this.mounting, this.mountingStage, this.stage});

  final Mounting mounting;
  final MountingStage mountingStage;
  final Stage stage;

  @override
  _MountStageState createState() => _MountStageState();
}

class _MountStageState extends State<MountStage> {
  final MountingController mountingController = Get.find();
  final loadingFlag = false.obs;
  final picker = ImagePicker();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.stage.name}'),
        ),
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: loadingFlag.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CommentField(controller: _commentController),
              ],
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
                          await mountingController.addMountingImage(
                              widget.mountingStage, imagePath);
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
                          await mountingController.addMountingImage(
                              widget.mountingStage, imagePath);
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
        ));
  }
}
