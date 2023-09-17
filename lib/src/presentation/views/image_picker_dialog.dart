import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seda/src/constants/constants_methods.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/menu_row.dart';
import 'package:sizer/sizer.dart';

class ImagePickerDialog extends StatelessWidget {
  const ImagePickerDialog({
    Key? key,
    required this.onImageSelect,
  }) : super(key: key);

  final Function(String path) onImageSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Container(
        height: 20.h,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
          color: AppColors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 20.w,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            MenuRow(
              title: context.takePic,
              onTap: () {
                pickImage(
                  ImageSource.camera,
                  onImageSelect,
                ).then((value) => Navigator.pop(context));
              },
              icon: Icons.camera_alt_outlined,
            ),
            MenuRow(
              title: context.selectGallery,
              onTap: () {
                pickImage(
                  ImageSource.gallery,
                  onImageSelect,
                ).then((value) => Navigator.pop(context));
              },
              icon: Icons.photo_library_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
