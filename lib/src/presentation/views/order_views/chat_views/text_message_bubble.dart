import 'package:flutter/material.dart';
import 'package:seda/src/constants/end_points.dart';
import 'package:seda/src/data/models/message_model.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class TextMessageBubble extends StatelessWidget {
  final MessageModel message;
  final String userName;
  final String userImage;
  final bool isSender;
  final bool isLast;

  const TextMessageBubble({
    Key? key,
    required this.message,
    this.isSender = false,
    this.isLast = false,
    required this.userName,
    required this.userImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Row(
            children: [
              isLast
                  ? SizedBox(
                      height: 5.h,
                      width: 5.h,
                      child: Container(
                        width: 13.h,
                        height: 13.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.midGrey.withOpacity(0.7),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: userImage.isNotEmpty
                            ? Image.network(
                                userImage,
                                fit: BoxFit.cover,
                              )
                            : const Padding(
                                padding: EdgeInsets.all(15),
                                child: FittedBox(
                                  child: Icon(
                                    Icons.person,
                                    color: AppColors.darkGrey,
                                    size: 65,
                                  ),
                                ),
                              ),
                      ),
                    )
                  : SizedBox(
                      width: 10.w,
                    ),
              SizedBox(
                width: 2.h,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 1.2.h),
                decoration: BoxDecoration(
                  color: isSender
                      ? AppColors.lightBlue.withOpacity(0.1)
                      : AppColors.lightGrey,
                  borderRadius: isSender
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20))
                      : const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                ),
                child: message.medias != null
                    ? Image.network(
                        "${EndPoints.imageBaseUrl}${message.medias!.filename}")
                    : DefaultText(
                        text: message.massage ?? '',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        textColor: AppColors.darkGrey,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
