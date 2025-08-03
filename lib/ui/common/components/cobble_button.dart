import 'package:cobble/ui/theme/cobble_theme.dart';
import 'package:cobble/ui/theme/with_cobble_theme.dart';
import 'package:flutter/material.dart';

/// Simple Cobble button.
///
/// [onPressed] parameter is required but can be null. At least one of [label]
/// and [icon] need be defined.
class CobbleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final String? label;
  final IconData? icon;
  final bool outlined;
  final Color? color;

  const CobbleButton({
    Key? key,
    required this.onPressed,
    this.label,
    this.icon,
    this.outlined = true,
    this.color,
    this.focusNode,
  })  : assert(
          label is String && label.length > 0 || icon is IconData,
          "CobbleButton needs label and/or icon",
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon is IconData) Icon(icon),
        if (icon is IconData && label is String) SizedBox(width: 8),
        if (label is String) Text(label!.toUpperCase()),
      ],
    );
    if (outlined)
      child = OutlinedButton(
        onPressed: onPressed,
        focusNode: focusNode,
        child: child,
      );
    else
      child = TextButton(
        onPressed: onPressed,
        focusNode: focusNode,
        child: child,
      );

    if (color != null) {
      child = CobbleButton.withColor(
        color: color!,
        child: child,
      );
    }

    return child;
  }

  static Widget withColor({
    required Color color,
    required Widget child,
  }) {
    return Builder(
      builder: (context) => Theme(
        data: context.theme.copyWith(
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: context.theme.outlinedButtonTheme.style?.copyWith(
              side: simpleMaterialStateProperty(
                BorderSide(color: color),
              ),
              foregroundColor: simpleMaterialStateProperty(
                color,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: context.theme.textButtonTheme.style?.copyWith(
              foregroundColor: simpleMaterialStateProperty(
                color,
              ),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
