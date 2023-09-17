import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seda/src/business_logic/cards_cubit/cards_cubit.dart';
import 'package:seda/src/constants/constants_variables.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/styles/app_colors.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:seda/src/presentation/widgets/default_text_field.dart';
import 'package:seda/src/presentation/widgets/toast.dart';
import 'package:sizer/sizer.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({Key? key}) : super(key: key);

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController cardController = TextEditingController();

  final TextEditingController expController = TextEditingController();

  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 55.h,
        color: isDark ? AppColors.darkGrey : AppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close_outlined,
                ),
              ),
              DefaultText(
                text: context.addCard,
                fontSize: 18.sp,
              ),
              DefaultTextField(
                height: 7.h,
                controller: nameController,
                hintText: context.cardName,
                borderColor: AppColors.lightGrey,
                textColor: AppColors.darkGrey,
                color: AppColors.lightGrey,
                textInputAction: TextInputAction.next,
              ),
              DefaultTextField(
                height: 7.h,
                controller: cardController,
                hintText: context.cardNumber,
                borderColor: AppColors.lightGrey,
                textColor: AppColors.darkGrey,
                color: AppColors.lightGrey,
                maxLength: 16,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.next,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DefaultTextField(
                    height: 7.h,
                    width: 44.w,
                    controller: expController,
                    hintText: context.exprDate,
                    borderColor: AppColors.lightGrey,
                    textColor: AppColors.darkGrey,
                    color: AppColors.lightGrey,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CardExpirationFormatter(),
                    ],
                    textInputAction: TextInputAction.next,
                  ),
                  DefaultTextField(
                    height: 7.h,
                    width: 44.w,
                    controller: cvvController,
                    hintText: context.cvv,
                    borderColor: AppColors.lightGrey,
                    textColor: AppColors.darkGrey,
                    color: AppColors.lightGrey,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultAppButton(
                    title: context.addCard,
                    onTap: () {
                      final name = nameController.text;
                      final cardNumber = cardController.text;
                      final cardExpr = expController.text;
                      final cardCVV = cvvController.text;
                      if (name.trim().isNotEmpty &&
                          cardNumber.trim().isNotEmpty &&
                          cardExpr.trim().isNotEmpty &&
                          cardCVV.trim().isNotEmpty &&
                          cardNumber.length.truncate() == 16) {
                        CardCubit.get(context).saveCard(
                          cardNumber: cardNumber,
                          month: cardExpr.split("/")[0],
                          year: cardExpr.split("/")[1],
                          cvc: cardCVV,
                          afterSuccess: () {
                            Navigator.pop(context);
                          },
                          error: () {
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        showToast(
                          context.addCardValidation,
                          color: AppColors.yellow,
                          textColor: AppColors.black,
                        );
                      }
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

class CardExpirationFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newValueString = newValue.text;
    String valueToReturn = '';

    for (int i = 0; i < newValueString.length; i++) {
      if (newValueString[i] != '/') valueToReturn += newValueString[i];
      var nonZeroIndex = i + 1;
      if (nonZeroIndex == 2) {
        final val = int.tryParse(valueToReturn);
        if (val == null || val > 12) {
          valueToReturn = valueToReturn.substring(0, 1);
          break;
        }
      }
      final contains = valueToReturn.contains(RegExp(r'/'));
      if (nonZeroIndex % 2 == 0 &&
          nonZeroIndex != newValueString.length &&
          !(contains)) {
        valueToReturn += '/';
      }
      if (nonZeroIndex == 4) break;
    }
    return newValue.copyWith(
      text: valueToReturn,
      selection: TextSelection.fromPosition(
        TextPosition(offset: valueToReturn.length),
      ),
    );
  }
}
