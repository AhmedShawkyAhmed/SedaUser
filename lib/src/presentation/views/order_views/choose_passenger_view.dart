import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';

import '../../../business_logic/location_cubit/location_cubit.dart';

class ChoosePassengerView extends StatefulWidget {
  const ChoosePassengerView({Key? key}) : super(key: key);

  @override
  State<ChoosePassengerView> createState() => _ChoosePassengerViewState();
}

class _ChoosePassengerViewState extends State<ChoosePassengerView> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: 100.w,
        // height: 90.h,
        padding: EdgeInsets.only(
          bottom: 1.h,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(50),
          ),
          color: isDark ? AppColors.darkGrey : AppColors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 1.2.h,
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
            DefaultText(
              text: context.choosePassenger,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 55),
              child: DefaultTextField(
                controller: controller,
                hintText: context.search,
                hintTextColor: isDark ? AppColors.lightGrey : AppColors.grey,
                borderColor: AppColors.lightGrey,
                height: 6.h,
                radius: 50,
                bottom: 2,
                padding: const EdgeInsets.only(left: 20, right: 12),
                suffix: Icon(
                  Icons.search_rounded,
                  size: 17.sp,
                  color: isDark ? AppColors.lightGrey : AppColors.grey,
                ),
              ),
            ),
            Divider(
              height: 1.5.h,
              thickness: 1,
              color: AppColors.lightGrey,
            ),
            SizedBox(
              height: 60.h,
              child: BlocBuilder<LocationCubit, LocationState>(
                builder: (context, state) {
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: 10,
                      itemBuilder: (context, position) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 1.5.h),
                              child: Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Icon(Icons.person,
                                          color: AppColors.darkGrey)),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DefaultText(
                                        text: "Hany Adel",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      DefaultText(
                                        text: "01001001010 ",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1.5.h,
                              thickness: 1,
                              color: AppColors.lightGrey,
                            ),
                          ],
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
