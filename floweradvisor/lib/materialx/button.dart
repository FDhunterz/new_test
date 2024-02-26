import 'package:flutter/material.dart';

class NoSplashButton extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  final Function()? onLongPress;
  const NoSplashButton({Key? key, required this.child, this.onTap, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}

class MaterialXButton extends StatelessWidget {
  final String? title;
  final Color? color,textColor;
  final Function? onTap;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  const MaterialXButton({Key? key, this.title = '', this.onTap, this.color, this.child, this.padding, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.blue,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
          child: Center(
            child: child ??
                Text(
                  '$title',
                  style:  TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
