import 'package:flutter/material.dart';
import 'package:seda/src/localization/language_strings.dart';
import 'package:seda/src/presentation/widgets/default_app_button.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';

class AddFavouriteBottomSheet extends StatelessWidget {
  const AddFavouriteBottomSheet({
    Key? key,
    required this.onAddFavourite,
  }) : super(key: key);
  final Function() onAddFavourite;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      // height: 35.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: DefaultText(text: context.addFavourite),
          ),
          DefaultAppButton(
            title: context.confirm,
            onTap: onAddFavourite,
          ),
        ],
      ),
    );
  }
}
