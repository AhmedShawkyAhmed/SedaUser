import 'package:flutter/material.dart';

class DefaultCheckBox extends StatefulWidget {
  const DefaultCheckBox({
    Key? key,
    required this.value,
    required this.onChange,
    this.size,
    this.iconSize,
    this.selectedColor,
    this.selectedIconColor,
    this.borderColor,
    this.checkIcon,
    this.borderRadius,
  }) : super(key: key);

  final bool? value;
  final Function(bool newValue) onChange;
  final double? size;
  final double? iconSize;
  final Color? selectedColor;
  final Color? selectedIconColor;
  final Color? borderColor;
  final Icon? checkIcon;
  final double? borderRadius;

  @override
  State<DefaultCheckBox> createState() => _DefaultCheckBoxState();
}

class _DefaultCheckBoxState extends State<DefaultCheckBox> {
  bool _checked = false;

  @override
  void didUpdateWidget(covariant DefaultCheckBox oldWidget) {
    if (widget.value != null) {
      setState(() {
        _checked = widget.value!;
      });
    }    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    _checked = widget.value ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _checked = !_checked;
          widget.onChange(_checked);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
            color: _checked
                ? widget.selectedColor ?? Colors.blue
                : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 3.0),
            border: Border.all(
              color: widget.borderColor ?? Colors.black,
              width: 1.5,
            )),
        width: widget.size ?? 18,
        height: widget.size ?? 18,
        child: _checked
            ? Icon(
                Icons.check,
                color: widget.selectedIconColor ?? Colors.white,
                size: widget.iconSize ?? 14,
              )
            : null,
      ),
    );
  }
}
