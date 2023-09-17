import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class PlaceView extends StatelessWidget {
  const PlaceView(
      {Key? key,
      required this.address,
      this.onTap,
      this.icon,
      this.onDelete,
      this.onUpdate,
      this.recent = true,
      required this.title})
      : super(key: key);

  final String address;
  final String title;
  final bool recent;
  final IconData? icon;
  final Function()? onTap;
  final Function()? onUpdate;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: isDark ? AppColors.darkGrey : null,
        width: 100.w,
        // height: 8.h,
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 5,
          // left: 25,
          // right: 25,
        ),
        child: Material(
          color: onTap != null ? AppColors.transparent : null,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.only(
                bottom: 10,
                top: 3,
                left: 25,
                right: 25,
              ),
              decoration: const BoxDecoration(
                //borderRadius: BorderRadius.circular(5),
                border: Border(
                  bottom: BorderSide(color: AppColors.lightGrey, width: 0.4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: recent ? -90 : 0,
                        child: Icon(
                          icon ??
                              (recent
                                  ? Icons.access_time_filled_outlined
                                  : Icons.favorite),
                          color: AppColors.darkGrey.withOpacity(0.8),
                          size: 15.sp,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DefaultText(
                          text: title,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        DefaultText(
                          text: address.isEmpty ? context.addLocation : address,
                          // text: address,
                          fontSize: 10.sp,
                          maxLines: 2,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                  if (onUpdate != null)
                    InkWell(
                      onTap: onUpdate,
                      child: const Icon(
                        Icons.update_rounded,
                        color: AppColors.lightRed,
                      ),
                    ),
                  if (onUpdate != null && onDelete != null)
                    const SizedBox(
                      width: 10,
                    ),
                  if (onDelete != null)
                    InkWell(
                      onTap: onDelete,
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.lightRed,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
