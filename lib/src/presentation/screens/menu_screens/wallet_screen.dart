import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/business_logic/wallet_cubit/wallet_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final pController = PageController();

  @override
  void initState() {
    WalletCubit.get(context).getWalletData();
    super.initState();
  }

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
          text: context.myWallet,
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
        if (state is WalletGetDataFailureState) {
          return Center(
            child: DefaultText(
              text: context.error,
              fontSize: 14,
            ),
          );
        } else if (state is WalletGetDataSuccessState) {
          var wallet = WalletCubit.get(context).wallet.data!.wallet!;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.h),
                      width: double.infinity,
                      height: 22.h,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.lightGrey : AppColors.white,
                        borderRadius: BorderRadius.circular(5.w),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey.withOpacity(0.5),
                            spreadRadius: 7,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DefaultText(
                            text: context.walletBalance,
                            fontSize: 16.sp,
                            textColor: isDark ? AppColors.darkGrey : null,
                          ),
                          DefaultText(
                            text: "${wallet.balance} \$",
                            textColor: isDark ? AppColors.darkGrey : null,
                            fontSize: 20.sp,
                          ),
                        ],
                      ),
                    ),
                    const DefaultText(text: 'My Transactions :'),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  color: AppColors.grey,
                ),
                Expanded(
                  child: wallet.transaction != null || wallet.transaction != []
                      ? SingleChildScrollView(
                          child: Column(
                            children: List.generate(
                              wallet.transaction!.length,
                              (index) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 1.h),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 2.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.black)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DefaultText(
                                      text: wallet.transaction![index].type!,
                                      textColor:
                                          isDark ? AppColors.darkGrey : null,
                                      fontSize: 20.sp,
                                    ),
                                    DefaultText(
                                      text: wallet.transaction![index].amount!,
                                      textColor:
                                          isDark ? AppColors.darkGrey : null,
                                      fontSize: 20.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: 20.h,
                          child: DefaultText(
                            text: 'no transactions found',
                            fontSize: 16.sp,
                            textColor: isDark ? AppColors.darkGrey : null,
                          ),
                        ),
                )
              ],
            ),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.primary,
          ));
        }
      }),
    );
  }
}
