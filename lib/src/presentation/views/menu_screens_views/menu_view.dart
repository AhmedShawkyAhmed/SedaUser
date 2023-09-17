import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/loading_indicator.dart';
import 'package:seda/src/presentation/widgets/menu_row.dart';
import 'package:sizer/sizer.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);
  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  List<MenuRow> menuList(BuildContext context) => [
        MenuRow(
          title: context.myWallet,
          icon: Icons.account_balance_wallet,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouterNames.wallet,
          ),
        ),
        MenuRow(
          title: context.cards,
          icon: Icons.credit_card,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouterNames.cards,
          ),
        ),
        MenuRow(
          title: context.history,
          icon: Icons.history,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterNames.history,
            );
          },
        ),
        MenuRow(
          title: context.promoCode,
          icon: Icons.local_offer_outlined,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRouterNames.myVoucher,
            );
          },
        ),
        MenuRow(
          title: context.settings,
          icon: Icons.settings,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouterNames.setting,
          ),
        ),
        MenuRow(
          title: context.inviteFriends,
          icon: Icons.card_giftcard_outlined,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouterNames.inviteFriends,
          ),
        ),
        MenuRow(
          title: context.becomeDriver,
          icon: Icons.drive_eta_rounded,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouterNames.becomeDriver,
          ),
        ),
        MenuRow(
          title: context.logout,
          icon: Icons.logout_outlined,
          onTap: () async {
            showDialog(
              context: context,
              builder: (context) => const LoadingIndicator(),
            );
            await AuthCubit.get(context).logout();
            CacheHelper.clearData().then(
              (value) => Future.delayed(const Duration(seconds: 1)).then(
                (value) => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouterNames.login,
                  (route) => false,
                ),
              ),
            );
          },
        ),
      ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 30.h,
            width: 100.w,
            decoration: const BoxDecoration(
              color: AppColors.midGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 22.h,
                    child: Image.asset(
                      "assets/images/logo4.png",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 25,
                    right: 20,
                    bottom: 10,
                  ),
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final user = AuthCubit.get(context).currentUser;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(
                                  Icons.close_outlined,
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRouterNames.profile);
                            },
                            child: Container(
                              width: 25.w,
                              height: 25.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: user?.image == null
                                  ? Padding(
                                      padding: EdgeInsets.all(5.w),
                                      child: const FittedBox(
                                        child: Icon(
                                          Icons.person,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    )
                                  : Image.network(
                                      "${EndPoints.imageBaseUrl}${user?.image}",
                                      fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRouterNames.profile);
                            },
                            child: DefaultText(
                              text: user?.name ?? '',
                              fontSize: 15.sp,
                              textColor: AppColors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Container(
                            width: 50.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color:
                                  isDark ? AppColors.darkGrey : AppColors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star_outlined,
                                    color: AppColors.orange,
                                  ),
                                  rating:
                                      double.tryParse("${user?.rate}") ?? 0.0,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  unratedColor: AppColors.lightGrey,
                                  textDirection: TextDirection.ltr,
                                  itemSize: 17.sp,
                                  itemPadding: const EdgeInsets.symmetric(
                                    horizontal: 1.0,
                                  ),
                                ),
                                DefaultText(
                                  text: "( ${user?.rate ?? 0.0} )",
                                  fontSize: 11.sp,
                                  textColor: AppColors.lightGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 55.h,
            color: isDark ? AppColors.darkGrey : AppColors.white,
            child: ListView.builder(
              itemCount: menuList(context).length,
              itemBuilder: (context, index) => MenuRow(
                title: menuList(context)[index].title,
                icon: menuList(context)[index].icon,
                onTap: menuList(context)[index].onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
