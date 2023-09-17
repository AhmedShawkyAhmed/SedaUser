import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/notification_cubit/notification_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/menu_screens_views/notification_card_view.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    NotificationCubit.get(context).getAllNotifications();
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
          text: context.notifications,
          fontSize: 18.sp,
          textColor: isDark ? AppColors.darkGrey : AppColors.white,
        ),
      ),
      body: SizedBox(
        height: 92.h,
        width: 100.w,
        child: ListView.builder(
          itemCount: 5,
          padding: EdgeInsets.only(top: 2.h),
          itemBuilder: (context, index) => NotificationCardView(
            onTap: () {},
            title: context.cong,
            subTitle: context.facilitateText,
          ),
        ),
      ),
    );
  }
}
