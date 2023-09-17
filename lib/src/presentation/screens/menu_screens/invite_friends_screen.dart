// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class InviteFriendsScreen extends StatelessWidget {
  InviteFriendsScreen({Key? key}) : super(key: key);
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkGrey : AppColors.fadedGreen,
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
          text: context.inviteFriends,
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
      ),
      body: Container(
        height: 70.h,
        width: 100.w,
        margin: EdgeInsets.only(
          top: 5.h,
          right: 5.w,
          left: 5.w,
        ),
        padding: const EdgeInsets.only(
          bottom: 30,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? AppColors.darkGrey : AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.7),
              spreadRadius: 4,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 90.w,
              child: Image.asset(
                "assets/images/invite.png",
              ),
            ),
            DefaultText(
              text: context.inviteFriendsGift,
              fontWeight: FontWeight.w400,
              fontSize: 15.sp,
            ),
            Container(
              width: 70.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: AppColors.midGrey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  DefaultText(
                    text: "15618sf5",
                    fontWeight: FontWeight.w400,
                    fontSize: 15.sp,
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 20.w,
                      height: 7.h,
                      decoration: BoxDecoration(
                        color: AppColors.midGreen,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.share,
                        color: AppColors.white,
                        size: 25.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
