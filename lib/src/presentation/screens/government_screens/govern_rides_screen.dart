// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class GovernsRidesScreen extends StatefulWidget {
  const GovernsRidesScreen({Key? key}) : super(key: key);

  @override
  State<GovernsRidesScreen> createState() => _GovernsRidesScreenState();
}

class _GovernsRidesScreenState extends State<GovernsRidesScreen> {
  final _controller = RefreshController();

  @override
  void initState() {
    super.initState();
    // GovernCubit.get(context).getValidSharedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkGrey : AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 12.h,
            width: double.infinity,
            padding: EdgeInsets.only(top: 2.5.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lightGreen,
                  AppColors.green,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 32,
                      color: AppColors.white,
                    )),
                DefaultText(
                    text: context.gov,
                    textColor: AppColors.white,
                    fontSize: 20.sp),
              ],
            ),
          ),
          Expanded(
              child: Center(
            child: DefaultText(
              text: 'Not available in your country',
              textColor: AppColors.black,
              fontSize: 20.sp,
            ),
          ))
          // Expanded(
          //   child: BlocBuilder<GovernCubit, GovernState>(
          //     builder: (context, state) {
          //       final cubit = GovernCubit.get(context);
          //       final trips = cubit.validModel?.data?.order ?? <Order>[];
          //       if (state is GetMyValidSharedOrdersLoadingState &&
          //           !_controller.isRefresh) {
          //         _controller.requestRefresh();
          //       } else {
          //         _controller.refreshCompleted();
          //       }
          //       return SmartRefresher(
          //         controller: _controller,
          //         onRefresh: cubit.getValidSharedOrders,
          //         child: ListView.separated(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: 2.h,
          //             vertical: 2.h,
          //           ),
          //           itemBuilder: (context, index) {
          //             final trip = trips[index];
          //             return Container(
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(15),
          //                 color: AppColors.grey.withOpacity(0.5),
          //               ),
          //               clipBehavior: Clip.antiAliasWithSaveLayer,
          //               child: InkWell(
          //                 onTap: () => Navigator.pushNamed(
          //                   context,
          //                   AppRouterNames.governDetails,
          //                   arguments: trip,
          //                 ),
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(10),
          //                   child: Row(
          //                     children: [
          //                       Container(
          //                         padding: const EdgeInsets.all(10),
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(10),
          //                           color:
          //                               AppColors.lightGreen.withOpacity(0.5),
          //                         ),
          //                         child: DefaultText(
          //                           fontSize: 13.sp,
          //                           text: trip.status ?? '_',
          //                         ),
          //                       ),
          //                       SizedBox(
          //                         width: 5.w,
          //                       ),
          //                       Expanded(
          //                         child: Column(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.start,
          //                           mainAxisAlignment: MainAxisAlignment.start,
          //                           children: [
          //                             Row(
          //                               children: [
          //                                 Expanded(
          //                                   child: DefaultText(
          //                                     text: trip.driver?.name ?? '_',
          //                                     fontSize: 15.sp,
          //                                   ),
          //                                 ),
          //                                 DefaultText(
          //                                   text: trip.valid == true
          //                                       ? 'Valid'
          //                                       : 'Full',
          //                                   textColor: trip.valid == true
          //                                       ? AppColors.green
          //                                       : AppColors.lightRed,
          //                                   fontSize: 13.sp,
          //                                 ),
          //                               ],
          //                             ),
          //                             SizedBox(
          //                               height: 11.5.h,
          //                               child: Row(
          //                                 crossAxisAlignment:
          //                                     CrossAxisAlignment.end,
          //                                 children: [
          //                                   SizedBox(
          //                                     width: 4.w,
          //                                     child: Column(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.end,
          //                                       children: [
          //                                         Container(
          //                                           width: 4.w,
          //                                           height: 4.w,
          //                                           decoration: BoxDecoration(
          //                                             color: AppColors.grey,
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                               50,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         Container(
          //                                           width: 2.w,
          //                                           height: 6.h,
          //                                           margin:
          //                                               EdgeInsets.symmetric(
          //                                             horizontal: 1.5.w,
          //                                           ),
          //                                           decoration: BoxDecoration(
          //                                             color: AppColors.grey,
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                               3,
          //                                             ),
          //                                           ),
          //                                         ),
          //                                         Container(
          //                                           width: 4.w,
          //                                           height: 4.w,
          //                                           decoration: BoxDecoration(
          //                                             color: AppColors.midGreen,
          //                                             borderRadius:
          //                                                 BorderRadius.circular(
          //                                               3,
          //                                             ),
          //                                           ),
          //                                         )
          //                                       ],
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 1.h,
          //                                   ),
          //                                   Expanded(
          //                                     child: Column(
          //                                       mainAxisAlignment:
          //                                           MainAxisAlignment.start,
          //                                       crossAxisAlignment:
          //                                           CrossAxisAlignment.stretch,
          //                                       children: [
          //                                         DefaultText(
          //                                           text: trip.fromLocation
          //                                                   ?.address ??
          //                                               '_',
          //                                         ),
          //                                         const Spacer(),
          //                                         DefaultText(
          //                                           text: trip.toLocation
          //                                                   ?.address ??
          //                                               '_',
          //                                         ),
          //                                         const SizedBox(
          //                                           height: 3,
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             )
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             );
          //           },
          //           separatorBuilder: (context, index) => SizedBox(
          //             height: 2.h,
          //           ),
          //           itemCount: trips.length,
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
