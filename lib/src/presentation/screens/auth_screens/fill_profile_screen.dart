import 'dart:io';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/constants/shared_preference_keys.dart';
import 'package:seda/src/data/data_provider/local/cache_helper.dart';
import 'package:seda/src/data/models/request_models/request_model.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/router/app_router_names.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/image_picker_dialog.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';

class FillProfileScreen extends StatefulWidget {
  const FillProfileScreen({Key? key}) : super(key: key);

  @override
  State<FillProfileScreen> createState() => _FillProfileScreenState();
}

class _FillProfileScreenState extends State<FillProfileScreen> {
  bool check = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController nickNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String dialCode = "+20";
  String? newImage;
  final countryPicker = const FlCountryCodePicker();
  Gender? gender;

  Future separatePhoneAndDialCode(String phoneWithDialCode) async {
    String code = '';
    for (var country in countryPicker.countryCodes) {
      String dialCode = country.dialCode;
      if (phoneWithDialCode.contains(dialCode)) {
        code = dialCode;
      }
    }

    if (dialCode.isNotEmpty) {
      var dialCode = phoneWithDialCode.substring(
        0,
        code.length,
      );
      var newPhoneNumber = phoneWithDialCode.substring(
        code.length,
      );
      setState(() {
        dialCode = dialCode;
        phoneController.text = newPhoneNumber;
      });
    }
  }

  @override
  void initState() {
    String phone = CacheHelper.getDataFromSharedPreference(
          key: SharedPreferenceKeys.gistPhone,
        ) ??
        '';
    separatePhoneAndDialCode(phone);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? AppColors.darkGrey : AppColors.white,
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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 25.h,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.asset(
                        "assets/images/logo2.png",
                        width: 50.w,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
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
                              Navigator.pushReplacementNamed(
                                  context, AppRouterNames.verification);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                      DefaultText(
                        text: context.fillProfile,
                        textColor: AppColors.white,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 25,
                      right: 25,
                      top: 5.h,
                      bottom: 10,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 32.w,
                          height: 32.w,
                          child: Stack(
                            children: [
                              Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color:
                                            AppColors.black1.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 5))
                                  ],
                                  borderRadius: BorderRadius.circular(20),
                                  image: newImage == null
                                      ? null
                                      : DecorationImage(
                                          image:
                                              Image.file(File(newImage!)).image,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                child: newImage == null
                                    ? Image.asset('assets/images/ic_person.png')
                                    : null,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  width: 7.w,
                                  height: 7.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreen,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet<dynamic>(
                                            isScrollControlled: true,
                                            backgroundColor:
                                                AppColors.transparent,
                                            context: context,
                                            builder: (BuildContext bc) {
                                              return ImagePickerDialog(
                                                onImageSelect: (String path) {
                                                  setState(() {
                                                    newImage = path;
                                                  });
                                                },
                                              );
                                            });
                                      },
                                      child: Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: AppColors.white,
                                        size: 15.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        DefaultTextField(
                          height: 6.h,
                          bottom: 0.5.h,
                          suffix: const SizedBox(),
                          controller: nameController,
                          hintText: context.fullName,
                          textColor: AppColors.grey,
                          color: AppColors.white,
                        ),
                        DefaultTextField(
                          height: 6.h,
                          bottom: 0.5.h,
                          controller: emailController,
                          hintText: context.email,
                          borderColor: AppColors.transparent,
                          textColor: AppColors.darkGrey,
                          color: AppColors.white,
                          keyboardType: TextInputType.emailAddress,
                          suffix: const Icon(
                            Icons.email_outlined,
                            color: AppColors.midGrey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DefaultTextField(
                              height: 6.h,
                              bottom: 0.5.h,
                              width: 42.w,
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: AppColors.midGreen,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  initialDate: DateTime(1940),
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime(
                                    2005,
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    birthDateController.text =
                                        DateFormat.yMd().format(value);
                                  }
                                });
                              },
                              suffix: const Icon(
                                Icons.date_range_rounded,
                                color: AppColors.midGrey,
                              ),
                              controller: birthDateController,
                              hintText: context.birthDate,
                              borderColor: AppColors.transparent,
                              textColor: AppColors.darkGrey,
                              color: AppColors.white,
                            ),
                            Container(
                              width: 42.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.white,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: DropdownButton<Gender>(
                                underline: const SizedBox(),
                                value: gender,
                                isExpanded: true,
                                hint: DefaultText(
                                  text: context.gender,
                                  fontWeight: FontWeight.w400,
                                  textColor:
                                      AppColors.darkGrey.withOpacity(0.7),
                                  fontSize: 15,
                                ),
                                icon: Transform.scale(
                                  scaleY: 2.3,
                                  scaleX: 1.3,
                                  child: const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.midGrey,
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: Gender.male,
                                    child: DefaultText(
                                      text: context.male,
                                      textColor:
                                          AppColors.darkGrey.withOpacity(0.7),
                                      fontSize: 15,
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: Gender.female,
                                    child: DefaultText(
                                      text: context.female,
                                      textColor:
                                          AppColors.darkGrey.withOpacity(0.7),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    gender = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        DefaultTextField(
                          height: 6.h,
                          bottom: 0.5.h,
                          controller: phoneController,
                          hintText: '01154338430',
                          readOnly: true,
                          textAlign: TextAlign.center,
                          cursorColor: isDark ? AppColors.white : null,
                          textColor: isDark ? AppColors.white : null,
                          borderColor: AppColors.transparent,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 30,
                    ),
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
                              color: check
                                  ? AppColors.lightGreen
                                  : AppColors.lightGrey,
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
                        InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, AppRouterNames.terms,
                              arguments: 0),
                          child: DefaultText(
                            text: context.termsApprove,
                            underLined: true,
                            fontSize: 10.sp,
                            textColor: check
                                ? AppColors.lightGreen
                                : AppColors.lightGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  DefaultAppButton(
                    title: context.cont,
                    textColor: AppColors.primary,
                    buttonColor: AppColors.white,
                    isGradient: false,
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRouterNames.home,
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
