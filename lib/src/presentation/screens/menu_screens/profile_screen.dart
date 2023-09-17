import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:seda/src/business_logic/auth_cubit/auth_cubit.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/data/models/request_models/request_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/views/custom_app_bar.dart';
import 'package:seda/src/presentation/views/image_picker_dialog.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:sizer/sizer.dart';
import 'dart:ui' as ui;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Gender? _gender;
  String? _image;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _edit = false;
  static const CameraPosition initial = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14,
  );

  @override
  void initState() {
    AuthCubit.get(context).getProfile();
    super.initState();
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
                  title: context.profile,
                  height: 165,
                  customWidget: const SizedBox(),
                  historyWidget: const SizedBox(),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthUpdateProfileSuccessState) {
                      Navigator.pop(context);
                      setState(() {
                        _birthDateController.clear();
                        _emailController.clear();
                        _nickNameController.clear();
                        _nameController.clear();
                        _image = null;
                        _edit = false;
                      });
                    }
                  },
                  builder: (context, state) {
                    final user = AuthCubit.get(context).currentUser;
                    return Padding(
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
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star_outlined,
                                  color: AppColors.orange,
                                ),
                                direction: Axis.horizontal,
                                itemCount: 5,
                                unratedColor: AppColors.grey,
                                textDirection: ui.TextDirection.ltr,
                                itemSize: 17.sp,
                                itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 1.0,
                                ),
                              ),
                              DefaultText(
                                text: "( ${user?.rate ?? '0.0'} )",
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
                            height: 7.h,
                            controller: _nameController,
                            hintText: user?.name ?? "Name",
                            borderColor: AppColors.lightGrey,
                            textColor: AppColors.darkGrey,
                            color: AppColors.lightGrey,
                            enabled: _edit,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          DefaultTextField(
                            height: 7.h,
                            controller: _nickNameController,
                            hintText: user?.nickName ?? "NickName",
                            borderColor: AppColors.lightGrey,
                            textColor: AppColors.darkGrey,
                            color: AppColors.lightGrey,
                            enabled: _edit,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          DefaultTextField(
                            height: 7.h,
                            controller: _birthDateController,
                            hintText: user?.birth ?? "BirthDate",
                            borderColor: AppColors.lightGrey,
                            textColor: AppColors.darkGrey,
                            color: AppColors.lightGrey,
                            enabled: _edit,
                            readOnly: true,
                            suffix: const Icon(
                              Icons.date_range_rounded,
                            ),
                            onTap: _edit
                                ? () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime(1980),
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime(2008),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                              primary: AppColors.lightGreen,
                                              // header background color
                                              onPrimary: AppColors.white,
                                              // header text color
                                              onSurface: AppColors
                                                  .darkGrey, // body text color
                                            ),
                                            textButtonTheme:
                                                TextButtonThemeData(
                                              style: TextButton.styleFrom(
                                                foregroundColor: AppColors
                                                    .black, // button text color
                                              ),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        final val =
                                            DateFormat("dd MMM, yyyy").format(
                                          value,
                                        );
                                        _birthDateController.text = val;
                                      }
                                    });
                                  }
                                : null,
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          DefaultTextField(
                            height: 7.h,
                            controller: _emailController,
                            hintText: user?.email ?? "Email Address",
                            borderColor: AppColors.lightGrey,
                            textColor: AppColors.darkGrey,
                            color: AppColors.lightGrey,
                            enabled: _edit,
                            suffix: const Icon(
                              Icons.email_outlined,
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          DefaultTextField(
                            height: 7.h,
                            controller: _phoneController,
                            hintText: user?.phone ?? "Phone Number",
                            borderColor: AppColors.lightGrey,
                            textColor: AppColors.darkGrey,
                            color: AppColors.lightGrey,
                            enabled: false,
                            suffix: const Icon(
                              Icons.phone_android_rounded,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DefaultAppButton(
                        title: _edit ? context.saveChanges : context.edit,
                        onTap: () {
                          if (_edit) {
                            final user = AuthCubit.get(context).currentUser;
                            String? name, nickname, birth, email;
                            name = (user?.name?.trim() !=
                                        _nameController.text.trim() &&
                                    _nameController.text.trim().isNotEmpty)
                                ? _nameController.text.trim()
                                : user?.name;
                            nickname = (user?.nickName?.trim() !=
                                        _nickNameController.text.trim() &&
                                    _nickNameController.text.trim().isNotEmpty)
                                ? _nickNameController.text.trim()
                                : user?.nickName;
                            email = (user?.email?.trim() !=
                                        _emailController.text.trim() &&
                                    _emailController.text.trim().isNotEmpty)
                                ? _emailController.text.trim()
                                : user?.email;
                            birth = (user?.birth?.trim() !=
                                        _birthDateController.text.trim() &&
                                    _birthDateController.text.isNotEmpty)
                                ? _birthDateController.text.trim()
                                : user?.birth;
                            if (name != null ||
                                nickname != null ||
                                email != null ||
                                birth != null ||
                                _image != null) {
                              showDialog(
                                context: context,
                                builder: (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              AuthCubit.get(context).updateProfile(
                                name: name,
                                nickName: nickname,
                                email: email,
                                birthDate: birth,
                                image: _image,
                              );
                            }
                          } else {
                            setState(() {
                              _edit = true;
                            });
                          }
                        },
                      ),
                      if (_edit)
                        const SizedBox(
                          height: 20,
                        ),
                      if (_edit)
                        DefaultAppButton(
                          title: context.cancel,
                          isGradient: true,
                          gradientColors: [
                            AppColors.red.withOpacity(0.8),
                            AppColors.red,
                          ],
                          onTap: () {
                            _nameController.clear();
                            _nickNameController.clear();
                            _emailController.clear();
                            _birthDateController.clear();
                            _image = null;
                            setState(() {
                              _edit = false;
                            });
                          },
                        ),
                    ],
                  ),
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
                child: Stack(
                  children: [
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final user = AuthCubit.get(context).currentUser;
                        return Container(
                          decoration: const BoxDecoration(
                            color: AppColors.lightGrey,
                            shape: BoxShape.circle,
                          ),
                          width: 30.w,
                          height: 30.w,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: _image == null
                              ? user?.image == null
                                  ? Padding(
                                      padding: EdgeInsets.all(5.w),
                                      child: const FittedBox(
                                        child: Icon(
                                          Icons.person,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    )
                                  : Image.network(
                                      "${EndPoints.imageBaseUrl}${user?.image}",
                                      fit: BoxFit.cover,
                                    )
                              : Image.file(
                                  File(_image!),
                                  fit: BoxFit.cover,
                                ),
                        );
                      },
                    ),
                    if (_edit && _image != null)
                      Positioned(
                        top: 10,
                        left: 5,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    if (_edit)
                      Positioned(
                        bottom: 10,
                        right: 5,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              builder: (_) => ImagePickerDialog(
                                onImageSelect: (image) {
                                  setState(() {
                                    _image = image;
                                  });
                                },
                              ),
                            );
                          },
                          child: const Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                  ],
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
