import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/presentation/views/app_language_dialog.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/settings_views/delete_account_dialog.dart';
import 'package:seda/src/presentation/views/menu_screens_views/settings_views/setting_row_view.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool notification = false;
  bool message = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        toolbarHeight: 8.h,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.white,
            size: 20.sp,
          ),
        ),
        title: DefaultText(
          text: context.settings,
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
      ),
      body: SizedBox(
        height: 92.h,
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 90.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SettingRowView(
                      title: context.security,
                      color: AppColors.blue,
                      icon: Icons.shield_outlined,
                      hasWidget: false,
                      widget: const SizedBox(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Divider(
                        color: AppColors.grey,
                        height: 1,
                      ),
                    ),
                    SettingRowView(
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const AppLanguageDialog(),
                      ),
                      title: context.language,
                      color: AppColors.orange,
                      icon: Icons.language_outlined,
                      hasWidget: false,
                      widget: const SizedBox(),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 90.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey : AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SettingRowView(
                      title: context.termsAndPolicy,
                      color: AppColors.pink,
                      icon: Icons.sticky_note_2_outlined,
                      hasWidget: false,
                      widget: const SizedBox(),
                      onTap: () {
                        Navigator.pushNamed(context, AppRouterNames.terms,arguments: 1);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Divider(
                        color: AppColors.grey,
                        height: 1,
                      ),
                    ),
                    SettingRowView(
                      title: context.contactUs,
                      color: AppColors.lightRed,
                      icon: Icons.phone,
                      hasWidget: false,
                      widget: const SizedBox(),
                      onTap: () {
                        // Navigator.pushNamed(
                        //     context, AppRouterNames.contacts);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DefaultAppButton(
                title: context.logout,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const LoadingIndicator(),
                  );
                  AuthCubit.get(context).logout();
                  CacheHelper.clearData()
                      .then((value) => Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRouterNames.login,
                            (route) => false,
                          ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              DefaultAppButton(
                title: context.deleteAccount,
                isGradient: true,
                gradientColors: [
                  AppColors.red.withOpacity(0.8),
                  AppColors.red,
                ],
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const DeleteAccountDialog(),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
