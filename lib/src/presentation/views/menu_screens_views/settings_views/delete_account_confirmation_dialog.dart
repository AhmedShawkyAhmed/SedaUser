import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({Key? key}) : super(key: key);

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
              text: context.deleteAccountMessage,
              fontSize: 12.sp,
              maxLines: 5,
              align: TextAlign.center,
            ),
            Divider(
              thickness: 1,
              height: 3.h,
            ),
            DefaultAppButton(
              title: context.confirm,
              onTap: () => Navigator.pop(
                context,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
