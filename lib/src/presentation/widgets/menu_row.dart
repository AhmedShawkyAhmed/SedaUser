import 'package:flutter/material.dart';
import 'package:seda/src/presentation/widgets/default_text.dart';
import 'package:sizer/sizer.dart';

class MenuRow extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final bool menuItem;

  const MenuRow({
    required this.title,
    required this.onTap,
    required this.icon,
    this.menuItem = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 10,
        left: 20,
        right: 20,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon),
            menuItem?const SizedBox(
              width: 10,
            ):const Spacer(),
            DefaultText(
              text: title,
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            )
          ],
        ),
      ),
    );
  }
}
