import 'package:drawing_animation/drawing_animation.dart';
import 'package:flutter/material.dart';
import 'package:seda/src/business_logic/global_cubit/global_cubit.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool run = true;
  bool text = false;

  @override
  initState() {
    GlobalCubit.get(context).navigate(
      afterSuccess: () {
        Navigator.pushReplacementNamed(context, AppRouterNames.home);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              AppColors.green,
              AppColors.midGreen,
              AppColors.darkGreen,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            run
                ? SizedBox(
                    width: 50.w,
                    height: 25.h,
                    child: AnimatedDrawing.svg(
                      "assets/images/logo.svg",
                      run: run,
                      duration: const Duration(milliseconds: 2500),
                      onFinish: () => setState(() {
                        run = false;
                        text = true;
                      }),
                    ),
                  )
                : SizedBox(
                    width: 50.w,
                    height: 25.h,
                    child: Image.asset("assets/images/logo.png"),
                  ),
            AnimatedContainer(
              width: text ? 50.w : 0,
              height: 8.h,
              color: AppColors.transparent,
              duration: const Duration(milliseconds: 1300),
              child: Center(
                child: DefaultText(
                  text: context.seda,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.normal,
                  overflow: TextOverflow.visible,
                  textColor: text ? AppColors.white : AppColors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
