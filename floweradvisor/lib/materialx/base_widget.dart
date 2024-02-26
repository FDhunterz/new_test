import 'dart:async';

import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:floweradvisor/materialx/page.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/materialx/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:request_api_helper/global_env.dart';

class NoSplashColor extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class BottomNavigationFunction {
  Function home, clinic, record, qr, health;
  BottomNavigationFunction({
    required this.clinic,
    required this.home,
    required this.qr,
    required this.record,
    required this.health,
  });
}

@optionalTypeArgs
abstract class BaseBackground<T extends StatefulWidget> extends State<T> with TickerProviderStateMixin {
  AnimationController? transitionController;
  Animation<double>? animationTransition;
  Function? lastWss;
  Future<void> navigator({StatefulWidget? page, Function? afterBack}) async {
    transitionController!.forward();
    await Navigator.push(context, slideRight(page: page)).then((value) {
      transitionController!.reverse();
      setState(() {});
    }).then((value) {});
    if (afterBack != null) {
      await afterBack();
    }
  }

  navigatorRemove({page}) async {
    transitionController!.forward();
    Navigator.pushAndRemoveUntil(context, slideRight(page: page), (route) => false);
  }

  getSizeBottom() {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  @override
  void initState() {
    super.initState();
    transitionController = AnimationController(
      duration: const Duration(
        milliseconds: 400,
      ),
      vsync: this,
    );
    animationTransition = CurvedAnimation(
      parent: transitionController!,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    if (transitionController != null) transitionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'This is Base Background v 0.0.1\nChange Your Widget',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

DateTime? currentNow;
Future<bool> _onWillPop(onBackPressed, {baseClass = false}) async {
  DateTime now = DateTime.now();
  if (currentNow == null) {
    currentNow = now;
    showToast(message: 'Tekan Kembali Lagi Untuk Keluar');
    Timer(const Duration(seconds: 2), () {
      currentNow = null;
    });
  } else if (currentNow!.difference(now).inSeconds < 4) {
    currentNow = null;
    if (baseClass) {
      CurrentPage.back();
    }
    if (!Navigator.canPop(ENV.navigatorKey.currentContext!)) {
      SystemNavigator.pop();
    }
    if (onBackPressed != null) {
      onBackPressed();
    }
    return true;
  }
  return false;
}

class InitControl extends StatelessWidget {
  final Widget? child;
  final bool? doubleClick;
  final Duration? delayPop;
  final bool? safeArea;
  final VoidCallback? onTapScreen;
  final Function? onBackPressed;
  final Widget? baseClass;

  const InitControl({Key? key, this.child, this.doubleClick, this.safeArea, this.onTapScreen, this.delayPop, this.onBackPressed, this.baseClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (baseClass != null) {
      CurrentPage.add(baseClass);
    }

    return PopScope(
      onPopInvoked: (v) async {
        if (doubleClick != null && doubleClick == true) {
          await _onWillPop(onBackPressed, baseClass: baseClass != null);
        } else {
          if (!Navigator.canPop(context)) {
            _onWillPop(onBackPressed, baseClass: baseClass != null);
          }

          if (onBackPressed != null) {
            onBackPressed!();
          }

          SystemChrome.restoreSystemUIOverlays();
          if (delayPop != null) {
            await Future.delayed(delayPop!, () {});
          }
          if (baseClass != null) {
            CurrentPage.back();
          }
        }
      },
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                final FocusScopeNode currentScope = FocusScope.of(context);
                if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
                SystemChrome.restoreSystemUIOverlays();
                if (onTapScreen != null) {
                  onTapScreen!();
                }
              },
              child: SafeArea(
                top: safeArea ?? false,
                bottom: safeArea ?? false,
                child: Fresher(
                  listener: MainController.state.isLoading, 
                  builder: (v,s){
                    return child!;
                }),
              ),
            ),
          ),
          Fresher(listener: MainController.state.isLoading, builder: (v,s){
            if(!v){
              return const SizedBox();
            }
            return Positioned(
              right: 10,
              bottom: 10,
              child: Image.asset('asset/loading.gif',width: 30,),);
          })
        ],
      ),
    );
  }
}


class StackFunction {
  int id;
  Function function;
  Timer? timer;

  StackFunction({required this.function, required this.id});
}

List<StackFunction> idStack = [];

replacedFunction(StackFunction data) {
  if (idStack.where((element) => element.id == data.id).isEmpty) {
    idStack.add(data);
  } else {
    idStack.where((element) => element.id == data.id).first.timer?.cancel();
    idStack.removeWhere((element) => element.id == data.id);
  }

  data.timer = Timer(const Duration(milliseconds: 500), () {
    idStack.removeWhere((element) => element.id == data.id);
    data.function();
  });
  idStack.add(data);
}
