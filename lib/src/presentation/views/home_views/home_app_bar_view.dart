import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seda/src/business_logic/app_cubit/app_cubit.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/menu_view.dart';
import 'package:seda/src/presentation/widgets/app_lang_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class HomeAppBarView extends StatefulWidget {
  const HomeAppBarView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeAppBarView> createState() => _HomeAppBarViewState();
}

class _HomeAppBarViewState extends State<HomeAppBarView> {
  late StreamController<bool> _logoStreamController;
  late bool _logo;

  DateTime time = DateTime.now();

  String getDayTime() {
    if (time.hour < 12) {
      return context.goodMorning;
    } else if (time.hour < 18) {
      return context.goodAfternoon;
    } else {
      return context.goodEvening;
    }
  }

  @override
  void initState() {
    super.initState();
    _logoStreamController = StreamController<bool>.broadcast();
    _logo = false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: AppColors.transparent,
                onTap: () {
                  _logo = true;
                  _logoStreamController.add(_logo);
                  Future.delayed(
                    const Duration(milliseconds: 120),
                    () {
                      _logo = false;
                      _logoStreamController.add(_logo);
                      showModalBottomSheet<dynamic>(
                        isScrollControlled: true,
                        backgroundColor: AppColors.transparent,
                        context: context,
                        builder: (BuildContext bc) {
                          return const MenuView();
                        },
                      );
                    },
                  );
                },
                child: StreamBuilder<bool>(
                    stream: _logoStreamController.stream,
                    initialData: _logo,
                    builder: (context, snapshot) {
                      return AnimatedContainer(
                        width: snapshot.data == true ? 11.w : 13.w,
                        // height: logo ? 11.w : 13.w,
                        duration: const Duration(milliseconds: 80),
                        child: Image.asset("assets/images/logo3.png"),
                      );
                    }),
              ),
              SizedBox(
                width: 1.w,
              ),
              SizedBox(
                width: 40.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultText(
                          text: getDayTime(),
                          textColor:
                              isDark ? AppColors.white : AppColors.darkGrey,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Calibri',
                          fontSize: 14.sp,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          "assets/images/waving_hand.png",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return DefaultText(
                          text: AuthCubit.get(context).currentUser?.name ??
                              "Ahmed Shawky",
                          textColor: isDark
                              ? AppColors.lightGrey
                              : AppColors.black1,
                          fontSize: 18.sp,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Calibri',
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              SizedBox(
                width: 30.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppLangButton(),
                    InkWell(
                      onTap: AppCubit.get(context).toggleTheme,
                      child: !isDark
                          ? SvgPicture.asset(
                              "assets/images/dark_mode.svg",
                              color: isDark
                                  ? AppColors.lightGrey
                                  : AppColors.darkGrey,
                            )
                          : Icon(
                              Icons.light_mode_outlined,
                              color: isDark
                                  ? AppColors.lightGrey
                                  : AppColors.darkGrey,
                              size: 20.sp,
                            ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouterNames.notifications,
                      ),
                      child: SvgPicture.asset(
                        "assets/images/notification.svg",
                        color: isDark
                            ? AppColors.lightGrey
                            : AppColors.darkGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
