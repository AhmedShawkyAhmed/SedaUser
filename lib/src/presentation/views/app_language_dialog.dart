import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class AppLanguageDialog extends StatefulWidget {
  const AppLanguageDialog({Key? key}) : super(key: key);

  @override
  State<AppLanguageDialog> createState() => _AppLanguageDialogState();
}

class _AppLanguageDialogState extends State<AppLanguageDialog> {
  final String ar = 'ar';
  final String en = 'en';
  String group = '';

  @override
  void initState() {
    final lang = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.appLanguageSharedKey,
        ) ??
        en;
    if (lang == ar) {
      group = ar;
    } else {
      group = en;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 3.h, bottom: 1.h),
                child: DefaultText(
                  text: context.appLangCh,
                  fontSize: 18.sp,
                ),
              ),
              RadioListTile<String>(
                value: ar,
                groupValue: group,
                onChanged: (val) => setState(() {
                  group = val!;
                }),
                title: Text.rich(
                  TextSpan(
                    text: context.arabic,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                    ),
                    children: const [
                      TextSpan(
                        text: " (AR)",
                      )
                    ],
                  ),
                ),
              ),
              RadioListTile<String>(
                value: en,
                groupValue: group,
                onChanged: (val) => setState(() {
                  group = val!;
                }),
                title: Text.rich(
                  TextSpan(
                    text: context.english,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                    ),
                    children: const [
                      TextSpan(
                        text: " (EN)",
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 2.h),
                child: DefaultAppButton(
                  title: context.confirm,
                  onTap: () async {
                    final app = AppCubit.get(context);
                    final lang =  CacheHelper.getDataFromSharedPreference(
                        key: SharedPreferenceKeys.appLanguageSharedKey);
                    if (lang == 'ar' && group == ar) {
                      showToast(context.appLangChErrAr);
                      return;
                    } else if (lang == 'en' && group == en) {
                      showToast(context.appLangChErrEn);
                      return;
                    } else if (group != ar && group != en) {
                      showToast(context.appLangChErrEmpty);
                      return;
                    }
                    app
                        .changeAppLanguage(Locale(group))
                        .then((value) => Navigator.pop(context));
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
