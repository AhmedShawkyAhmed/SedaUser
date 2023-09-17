import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seda/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class AppLangButton extends StatelessWidget {
  const AppLangButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        final locale = AppCubit.get(context).locale;
        return SizedBox(
          height: 6.h,
          width: 6.h,
          child: Center(
            child: DropdownButton<Locale>(
              isExpanded: true,
              icon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 1.w,
                ),
                child: SvgPicture.asset(
                  "assets/images/language.svg",
                  color: isDark ? AppColors.lightGrey : AppColors.darkGrey,
                ),
              ),
              underline: const SizedBox(),
              items: AppLocalizations.supportedLocales
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: DefaultText(
                        text: e.languageCode.toUpperCase(),
                        fontSize: 15,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val?.languageCode == locale.languageCode) {
                  final isAr =
                      val?.languageCode == const Locale("ar").languageCode;
                  isAr
                      ? showToast(
                          context.appLangChErrAr,
                          gravity: ToastGravity.SNACKBAR,
                          color: AppColors.lightRed,
                        )
                      : showToast(
                          context.appLangChErrEn,
                          gravity: ToastGravity.SNACKBAR,
                          color: AppColors.lightRed,
                        );
                  return;
                }
                if (val != null) {
                  cubit.changeAppLanguage(val);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
