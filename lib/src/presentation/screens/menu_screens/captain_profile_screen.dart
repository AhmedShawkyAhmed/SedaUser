import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/user_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/custom_app_bar.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CaptainProfileScreen extends StatefulWidget {
  const CaptainProfileScreen({Key? key, required this.captain})
      : super(key: key);
  final UserModel captain;

  @override
  State<CaptainProfileScreen> createState() => _CaptainProfileScreenState();
}

class _CaptainProfileScreenState extends State<CaptainProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String dialCode = "+20";
  final countryPicker = const FlCountryCodePicker();
  double rate = 3.5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.captain.name!;
    nickNameController.text = widget.captain.nickName ?? 'No nickname added';
    birthDateController.text = widget.captain.birth ?? 'No birthdate added';
    emailController.text = widget.captain.email ?? '';
    phoneController.text = widget.captain.phone ?? '';
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  title: context.capProf,
                  height: 165,
                  customWidget: const SizedBox(),
                  historyWidget: const SizedBox(),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                    left: 25,
                    right: 25,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RatingBarIndicator(
                            direction: Axis.horizontal,
                            itemCount: 5,
                            unratedColor: AppColors.grey,
                            textDirection: TextDirection.ltr,
                            itemSize: 17.sp,
                            rating: double.parse(widget.captain.rate ?? '0'),
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_outlined,
                              color: AppColors.orange,
                            ),
                          ),
                          DefaultText(
                            text: "( ${widget.captain.rate ?? '0'} )",
                            fontSize: 11.sp,
                            textColor: AppColors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      DefaultTextField(
                        enabled: false,
                        height: 7.h,
                        controller: nameController,
                        hintText: context.fullName,
                        borderColor: AppColors.lightGrey,
                        textColor: AppColors.darkGrey,
                        color: AppColors.lightGrey,
                      ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // DefaultTextField(
                      //   enabled: true,
                      //   height: 7.h,
                      //   controller: nickNameController,
                      //   hintText: context.nickName,
                      //   borderColor: AppColors.lightGrey,
                      //   textColor: AppColors.darkGrey,
                      //   color: AppColors.lightGrey,
                      // ),
                      SizedBox(
                        height: 3.h,
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _makePhoneCall(phoneController.text);
                        }),
                        child: DefaultTextField(
                          enabled: false,
                          height: 7.h,
                          controller: phoneController,
                          hintText: context.phone,
                          borderColor: AppColors.lightGrey,
                          textColor: AppColors.darkGrey,
                          color: AppColors.lightGrey,
                        ),
                      ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // DefaultTextField(
                      //   enabled: true,
                      //   height: 7.h,
                      //   controller: birthDateController,
                      //   hintText: "Gender",
                      //   borderColor: AppColors.lightGrey,
                      //   textColor: AppColors.darkGrey,
                      //   color: AppColors.lightGrey,
                      // ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // DefaultTextField(
                      //   enabled: false,
                      //   height: 7.h,
                      //   controller: birthDateController,
                      //   hintText: context.birthDate,
                      //   borderColor: AppColors.lightGrey,
                      //   textColor: AppColors.darkGrey,
                      //   color: AppColors.lightGrey,
                      // ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // DefaultTextField(
                      //   enabled: true,
                      //   height: 7.h,
                      //   controller: birthDateController,
                      //   hintText: context.carType,
                      //   borderColor: AppColors.lightGrey,
                      //   textColor: AppColors.darkGrey,
                      //   color: AppColors.lightGrey,
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 30.w,
                  height: 30.w,
                  child: Image.asset(
                    "assets/images/person.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20),
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Image.asset("assets/images/logo4.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
