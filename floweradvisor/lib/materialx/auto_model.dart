import 'package:flutter/cupertino.dart';

class Fresh<T> extends ChangeNotifier {
  late ValueNotifier<T> listener;

  T get value => listener.value;

  Fresh(T values) {
    listener = ValueNotifier<T>(values);
  }

  refresh(Function(ValueNotifier<T> listener) function, {Function(Object err)? error}) async {
    try {
      await function(listener);
      listener.notifyListeners();
    } catch (_) {
      if (error != null) {
        error(_);
      }
    }
  }
}

class Fresher<T> extends StatelessWidget {
  final Fresh<T> listener;
  final Function(T value, void Function(void Function()) state) builder;
  const Fresher({Key? key, required this.listener, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: listener.listener,
      builder: (_, v, __) {
        return StatefulBuilder(
          builder: (context, setState) {
            return builder(v, setState);
          },
        );
      },
    );
  }
}
