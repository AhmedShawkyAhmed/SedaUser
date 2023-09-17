import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/settings_views/delete_account_confirmation_dialog.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultText(
              text: context.deleteAccount,
              fontSize: 13.sp,
            ),
            Divider(
              thickness: 2,
              height: 3.h,
            ),
            DefaultText(
              text: context.deleteAccountWarning,
              fontSize: 12.sp,
              maxLines: 5,
              align: TextAlign.center,
            ),
            Divider(
              thickness: 2,
              height: 5.h,
            ),
            Row(
              children: [
                Expanded(
                  child: DefaultAppButton(
                    title: context.confirm,
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => const DeleteAccountConfirmationDialog(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Expanded(
                  child: DefaultAppButton(
                    isGradient: true,
                    gradientColors: [
                      AppColors.red.withOpacity(0.8),
                      AppColors.red,
                    ],
                    title: context.cancel,
                    onTap: () => Navigator.pop(
                      context,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
