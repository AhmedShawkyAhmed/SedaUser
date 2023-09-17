import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/order_cubit/order_cubit.dart';
import '../../widgets/loading_indicator.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key, required this.newOrder}) : super(key: key);

  final bool newOrder;

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    shipmentTypeId = 2;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        if (paymentTypeId == 1) {
          wallet = true;
        } else if (paymentTypeId == 2) {
          paymentMethods(context)[0][2] = true;
        } else {
          paymentMethods(context)[1][2] = true;
        }
      }
    });
  }

  bool wallet = false;

  // List<bool> selected = [];

  paymentMethods(BuildContext context) => <List<dynamic>>[
        ['assets/images/visa.svg', '****2454', false, 2],
        // ['assets/images/applePay.svg', 'Apple Pay', false],
        ['assets/images/cash1.svg', context.cash, false, 3]
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 100.w,
                height: 46.h,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkGrey : AppColors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 1.5.h,
                    ),
                    Container(
                      height: 1.w,
                      width: 15.w,
                      decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      children: [
                        DefaultText(
                          text: context.sedaCash,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 5),
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(2)),
                              child: DefaultText(
                                text: context.seda,
                                fontSize: 10.sp,
                                textColor: isDark
                                    ? AppColors.lightGrey
                                    : AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DefaultText(
                                  text: context.walletBalance,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                DefaultText(
                                  text: '0.00 SAR',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ],
                            ),
                          ],
                        ),
                        FlutterSwitch(
                          width: 42,
                          height: 22,
                          toggleSize: 18,
                          value: wallet,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.grey,
                          borderRadius: 30.0,
                          padding: 2,
                          onToggle: (val) {
                            setState(() {
                              if (widget.newOrder) {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return const LoadingIndicator();
                                  },
                                );
                                OrderCubit.get(context).changePayment(
                                  paymentTypeId: 1,
                                  afterError: () {
                                    Navigator.pop(context);
                                  },
                                  afterSuccess: (id) {
                                    setState(() {
                                      wallet = val;
                                      paymentTypeId = id;
                                      if (wallet) {
                                        for (int i = 0;
                                            i < paymentMethods(context).length;
                                            i++) {
                                          paymentMethods(context)[i][2] = false;
                                        }
                                      } else {
                                        paymentMethods(context)[1][2] = true;
                                      }
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                setState(() {
                                  wallet = val;
                                  if (wallet) {
                                    for (int i = 0;
                                        i < paymentMethods(context).length;
                                        i++) {
                                      paymentMethods(context)[i][2] = false;
                                    }
                                    paymentTypeId = 1;
                                  } else {
                                    paymentMethods(context)[1][2] = true;
                                    paymentTypeId = 3;
                                  }
                                });
                                Navigator.pop(context);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        height: 10,
                        thickness: 1,
                        color: AppColors.lightGrey,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Align(
                      alignment: context.isAr
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: DefaultText(
                        text: context.paymentMethods,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      height: 7.h * paymentMethods(context).length,
                      child: ListView.separated(
                        itemCount: paymentMethods(context).length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (widget.newOrder) {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const LoadingIndicator();
                                    },
                                  );
                                  OrderCubit.get(context).changePayment(
                                    paymentTypeId:
                                        paymentMethods(context)[index][3],
                                    afterError: () {
                                      Navigator.pop(context);
                                    },
                                    afterSuccess: (id) {
                                      setState(() {
                                        paymentMethods(context)[index][2] =
                                            true;
                                        wallet = false;
                                        paymentTypeId = id;
                                        for (int i = 0;
                                            i < paymentMethods(context).length;
                                            i++) {
                                          if (i != index) {
                                            paymentMethods(context)[i][2] =
                                                false;
                                          }
                                        }
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  );
                                } else {
                                  setState(() {
                                    paymentMethods(context)[index][2] = true;
                                    wallet = false;
                                    paymentTypeId =
                                        paymentMethods(context)[index][3];
                                    for (int i = 0;
                                        i < paymentMethods(context).length;
                                        i++) {
                                      if (i != index) {
                                        paymentMethods(context)[i][2] = false;
                                      }
                                    }
                                  });
                                  Navigator.pop(context);
                                }
                              });
                            },
                            child: SizedBox(
                              height: 6.h,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    paymentMethods(context)[index][0],
                                    color: index == 0
                                        ? isDark
                                            ? AppColors.white
                                            : null
                                        : null,
                                  ),
                                  const SizedBox(
                                    width: 25,
                                  ),
                                  DefaultText(
                                    text: paymentMethods(context)[index][1],
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const Spacer(),
                                  if (paymentMethods(context)[index][2])
                                    const Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, position) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              height: 10,
                              thickness: 1,
                              color: AppColors.lightGrey,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
