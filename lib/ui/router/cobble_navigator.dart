import 'package:cobble/ui/router/cobble_screen.dart';
import 'package:flutter/cupertino.dart';

extension CobbleNavigator on BuildContext {
  Future<T?> push<T extends Object>(CobbleScreen? page) {
    return Navigator.of(this).push(CupertinoPageRoute<T>(builder: (_) => page!));
  }

  /// Pushes a new screen on top of the root navigator stack.
  Future<T?> pushRoot<T extends Object>(CobbleScreen page) {
    return Navigator.of(this, rootNavigator: true)
        .push(CupertinoPageRoute<T>(builder: (_) => page));
  }

  Future<T?> pushReplacement<T extends Object, TO extends Object>(
    CobbleScreen page, {
    TO? result,
  }) {
    return Navigator.of(this).pushReplacement(
      CupertinoPageRoute<T>(builder: (_) => page),
      result: result,
    );
  }

  Future<T?> pushAndRemoveAllBelow<T extends Object>(CobbleScreen page) {
    return Navigator.of(this).pushAndRemoveUntil(
      CupertinoPageRoute<T>(builder: (_) => page),
      (_) => false,
    );
  }

  void pop<T extends Object>([T? result]) {
    Navigator.of(this).pop(result);
  }
}
