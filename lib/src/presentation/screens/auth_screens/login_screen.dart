import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool check = false;
  String dialCode = "+966";
  final countryPicker =
      const FlCountryCodePicker(filteredCountries: ['SA', 'EG']);
  final fromKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkGrey : null,
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
        child: Padding(
          padding: const EdgeInsets.only(
            top: 50,
            left: 25,
            right: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  width: 100.w,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/images/logo2.png",
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: DefaultText(
                          text: context.login,
                          textColor: AppColors.white,
                          fontSize: 35.sp,
                          maxLines: 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Column(
                  children: [
                    DefaultTextField(
                      controller: phoneController,
                      hintText: '',
                      cursorColor: isDark ? AppColors.white : null,
                      textColor: isDark ? AppColors.white : null,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        //To remove first '0'
                        FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      ],
                      borderColor: AppColors.lightGreen,
                      color: AppColors.fromHex('#EEFAF7'),
                      keyboardType: TextInputType.phone,
                      height: 7.h,
                      bottom: 0,
                      prefix: InkWell(
                        onTap: () async {
                          final code =
                              await countryPicker.showPicker(context: context);
                          setState(() {
                            if (code != null) {
                              dialCode = code.dialCode;
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 5,
                          ),
                          child: SizedBox(
                            width: 23.w,
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.phone_iphone_outlined,
                                  color: AppColors.green,
                                ),
                                DefaultText(
                                  text: dialCode,
                                  fontSize: 10.sp,
                                ),
                                Transform.scale(
                                  scaleX: 1.2,
                                  scaleY: 1.5,
                                  child: Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.midGrey,
                                    size: 20.sp,
                                  ),
                                ),
                                Container(
                                  width: 0.5.w,
                                  height: 3.h,
                                  decoration: const BoxDecoration(
                                    color: AppColors.midGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    DefaultAppButton(
                      title: context.singIn,
                      textColor: AppColors.primary,
                      buttonColor: AppColors.white,
                      isGradient: false,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouterNames.verification,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
