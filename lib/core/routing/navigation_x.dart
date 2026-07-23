import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Safe back navigation: pops normally when there is a previous route,
/// otherwise navigates to [fallbackRoute] instead of throwing.
///
/// Pages can be the first route in the stack (context.go, gate redirects,
/// deep links), where a raw context.pop() throws.
extension SafeNavigationX on BuildContext {
  /// Pops if possible, otherwise `go(fallbackRoute)`.
  /// [result] is forwarded to the popped route when popping.
  void safePopOrGo(String fallbackRoute, {Object? result}) {
    if (canPop()) {
      pop(result);
    } else {
      go(fallbackRoute);
    }
  }
}
