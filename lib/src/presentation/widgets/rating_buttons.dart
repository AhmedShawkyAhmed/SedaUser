import 'package:flutter/material.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class RatingButtons extends StatefulWidget {
  final double width;
  final String text;

  const RatingButtons({
    required this.text,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  State<RatingButtons> createState() => _RatingButtonsState();
}

class _RatingButtonsState extends State<RatingButtons> {
  bool check = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          check = !check;
        });
      },
      child: Container(
        width: widget.width,
        height: 5.h,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: check ? AppColors.midGreen : AppColors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.12),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: DefaultText(
            text: widget.text,
            fontSize: 10.sp,
            textColor: check ? AppColors.white : AppColors.darkGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
