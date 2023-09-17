import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants_variables.dart';

class QuickLocation extends StatelessWidget {
  final IconData icon;
  final String? title;
  final String address;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const QuickLocation({
    this.title,
    required this.address,
    required this.icon,
    required this.onTap,
    this.onDelete,
    this.onUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 5,
        // left: 25,
        // right: 25,
      ),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.only(
              bottom: 5,
              top: 5,
              left: 20,
              right: 20,
            ),
            width: 35.w,
            decoration: const BoxDecoration(
              //borderRadius: BorderRadius.circular(5),
              border: Border(
                bottom: BorderSide(color: AppColors.lightGrey, width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  // width: 5.w,
                  // height: 4.w,
                  radius: 20,
                  backgroundColor: AppColors.lightGrey,
                  child: Transform.rotate(
                    angle: title == context.home || title == context.work
                        ? 0
                        : -90,
                    child: Icon(
                      icon,
                      color: AppColors.darkGrey,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 70.w,
                        child: DefaultText(
                          text: title ?? 'title',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor:
                              isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 70.w,
                        child: DefaultText(
                          text: address,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textColor:
                              isDark ? AppColors.lightGrey : AppColors.darkGrey,
                        ),
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
    );
  }
}
