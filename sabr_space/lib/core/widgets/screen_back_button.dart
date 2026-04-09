import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sabr_space/core/theme/theme_palette.dart';

/// Pops the current route, or navigates to [fallbackLocation] when the stack
/// cannot pop (e.g. drawer `go` navigation).
void navigateBack(BuildContext context, {String fallbackLocation = '/home'}) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
  } else {
    router.go(fallbackLocation);
  }
}

/// Single back control for shell screens — inline with content, not a floating overlay.
class ScreenBackButton extends StatelessWidget {
  const ScreenBackButton({
    super.key,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 20,
  });

  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final tooltip = MaterialLocalizations.of(context).backButtonTooltip;
    return IconButton(
      onPressed: onPressed ?? () => navigateBack(context),
      tooltip: tooltip,
      icon: Icon(Icons.arrow_back_ios_new_rounded, size: iconSize),
      style: IconButton.styleFrom(
        foregroundColor: iconColor ?? context.palette.primary,
        backgroundColor: backgroundColor,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.all(10),
        minimumSize: const Size(40, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
