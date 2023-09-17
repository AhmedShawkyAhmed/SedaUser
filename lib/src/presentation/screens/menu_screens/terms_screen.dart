import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool check = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 7.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 11.w,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
              DefaultText(
                text: context.terms,
                textColor: AppColors.black,
              ),
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            flex: 8,
            child: Container(
                color: AppColors.midGrey.withOpacity(0.2),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: DefaultText(
                    text: context.termsText,
                    fontSize: 13.sp,
                    textColor: AppColors.darkGrey,
                    maxLines: 100,
                  ),
                ),
            ),
          ),
          if(widget.key==const ValueKey(0))
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              check = !check;
                            });
                          },
                          child: Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color:
                                  check ? AppColors.green : AppColors.midGrey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Image.asset(
                                "assets/images/logo.png",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DefaultText(
                          text: context.termsApprove,
                          underLined: true,
                          fontSize: 10.sp,
                          textColor:
                              check ? AppColors.green : AppColors.midGrey,
                        ),
                      ],
                    ),
                  ),
                  DefaultAppButton(
                    title: context.cont,
                    textColor: AppColors.white,
                    isGradient: true,
                    gradientColors: const [
                      AppColors.green,
                      AppColors.midGreen,
                      AppColors.darkGreen,
                    ],
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
