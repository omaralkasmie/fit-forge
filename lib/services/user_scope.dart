import 'package:flutter/widgets.dart';

import 'user_manager.dart';

class UserScope extends InheritedNotifier<UserManager> {
  const UserScope({
    super.key,
    required UserManager notifier,
    required super.child,
  }) : super(notifier: notifier);

  static UserManager of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<UserScope>();

    assert(scope != null, 'UserScope not found in widget tree');

    return scope!.notifier!;
  }
}