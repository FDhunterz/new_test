import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sql_query/viewer/model/auto_model.dart';

import 'currency.dart';

enum FormStatus { success, error, nothing }

var regex = RegExp(r'[a-zA-Z?=*[!@#$%^&*£(){_+}]');
var regexEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

bool fillFunction(MaterialXFormController controller, String? data) {
  controller.controller!.text = data ?? '';
  if (controller.controller!.text.isNotEmpty) {
    controller.status = FormStatus.success;
    return true;
  }
  return false;
}

class MaterialXFormController {
  bool isRequired, onlySuccessParameter;
  TextEditingController? controller;
  FormStatus status;
  FocusNode? focusNode;
  Fresh<bool> isFocused = Fresh(false);
  Widget? suffix, prefix;

  dispose() {
    controller?.dispose();
    focusNode?.dispose();

    isFocused.dispose();
  }

  MaterialXFormController changeSuffix(suffixs) {
    prefix = null;
    suffix = suffixs;
    return this;
  }

  MaterialXFormController changePrefix(prefixs) {
    suffix = null;
    prefix = prefixs;
    return this;
  }

  isEmpty() {
    return controller == null || controller?.text == '';
  }

  static bool check(List<MaterialXFormController> controller) {
    bool result = true;
    for (var i in controller) {
      if (i.isEmpty()) {
        result = false;
        i.status = FormStatus.error;
      }
    }
    return result;
  }

  clearText() {
    controller!.text = '';
  }

  MaterialXFormController({Key? key, this.isRequired = false, this.controller, this.status = FormStatus.nothing, this.suffix, this.prefix, this.onlySuccessParameter = true}) {
    controller ??= TextEditingController();
    focusNode ??= FocusNode();

    focusNode?.addListener(() {
      isFocused.refresh((listener) => listener.value = focusNode?.hasFocus ?? false);
    });
  }
}

class MaterialXForm extends StatelessWidget {
  final bool flat;
  final double scaled;
  final MaterialXFormController controller;
  final String? title, hintText;
  final Function? onPressEnter;
  final bool centerTextField;
  final bool isEnabled;
  final Function? onTap;
  final int? maxLines;
  final Widget? group, errorWidget;
  final bool isNumber, isCurrency, obsecure;
  final Widget? customChild;
  final Color? textColor;
  final Function(String)? onChanged;

  const MaterialXForm({
    Key? key,
    required this.controller,
    this.title,
    this.hintText = '',
    this.textColor,
    this.onPressEnter,
    this.centerTextField = false,
    this.isEnabled = true,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.group,
    this.isNumber = false,
    this.isCurrency = false,
    this.obsecure = false,
    this.customChild,
    this.scaled = 1.0,
    this.flat = false,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return GestureDetector(
        onTap: () async {
          if (!isEnabled) {
            if (onTap != null) {
              await onTap!();
            }
          } else {
            controller.focusNode?.requestFocus();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: flat ? EdgeInsets.zero : const EdgeInsets.only(bottom: 6.0),
              child: title == null
                  ? const SizedBox()
                  : Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '$title',
                        ),
                        TextSpan(
                          text: controller.isRequired ? '*' : '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ]),
                      style: TextStyle(
                        fontSize: 13 * scaled,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Fresher<bool>(
                          listener: controller.isFocused,
                          builder: (isFocused) {
                            return Container(
                              padding: flat ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: flat
                                    ? Colors.transparent
                                    : controller.status == FormStatus.error
                                        ? Colors.red.withOpacity(0.2)
                                        : controller.status == FormStatus.success
                                            ? Colors.green.withOpacity(0.2)
                                            : Colors.white10,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                border: controller.status == FormStatus.error
                                    ? Border.all(width: 1, color: flat ? Colors.transparent : Colors.red)
                                    : controller.status == FormStatus.success
                                        ? Border.all(width: 1, color: flat ? Colors.transparent : Theme.of(context).primaryColor)
                                        : isFocused
                                            ? Border.all(width: 1, color: flat ? Colors.transparent : Theme.of(context).primaryColor)
                                            : Border.all(width: 1, color: flat ? Colors.transparent : Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                crossAxisAlignment: centerTextField ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                                children: [
                                  controller.prefix ?? const SizedBox(),
                                  Expanded(
                                    child: customChild ??
                                        TextField(
                                          focusNode: controller.focusNode,
                                          controller: controller.controller,
                                          autocorrect: true,
                                          keyboardType: isNumber || isCurrency ? TextInputType.phone : null,
                                          textAlign: centerTextField ? TextAlign.center : TextAlign.start,
                                          style: TextStyle(
                                            color: textColor ?? Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16 * scaled,
                                          ),
                                          scrollPadding: EdgeInsets.zero,
                                          obscureText: obsecure,
                                          onChanged: (text) async {
                                            if (isNumber || isCurrency) {
                                              text = text.replaceAll(regex, '');
                                              if(text == ''){
                                                controller.controller!.text = '';
                                              }
                                            }
                                            if (isCurrency) {
                                              currencyFormat(
                                                controller: controller.controller!,
                                                data: text,
                                              );
                                            }
                                            if (text.isEmpty && controller.isRequired) {
                                              controller.status = FormStatus.error;
                                              state(() {});
                                            } else if (text.isNotEmpty && controller.isRequired) {
                                              controller.status = FormStatus.success;
                                              state(() {});
                                            } else if (text.isNotEmpty && controller.onlySuccessParameter) {
                                              controller.status = FormStatus.success;
                                              state(() {});
                                            } else {
                                              controller.status = FormStatus.nothing;
                                              state(() {});
                                            }
                                            if (onChanged != null) {
                                              await onChanged!(text);
                                              state(() {});
                                            }
                                          },
                                          onTap: () async {
                                            if (isCurrency || isNumber) {
                                              if (controller.controller!.text == '0') {
                                                controller.controller!.text = '';
                                              }
                                            }
                                            if (onTap != null) {
                                              await onTap!();
                                            }
                                          },
                                          onEditingComplete: () {
                                            if (onPressEnter != null) {
                                              onPressEnter!();
                                            }
                                            final FocusScopeNode currentScope = FocusScope.of(context);
                                            if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                                              FocusManager.instance.primaryFocus!.unfocus();
                                            }
                                          },
                                          decoration: InputDecoration(
                                            enabled: isEnabled,
                                            counterText: '',
                                            contentPadding: EdgeInsets.zero,
                                            isDense: true,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: '$hintText',
                                            hintStyle: TextStyle(
                                              color: textColor?.withOpacity(0.45) ?? Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12 * scaled,
                                            ),
                                          ),
                                          maxLines: maxLines,
                                        ),
                                  ),
                                  controller.suffix ??
                                      // (controller.status == FormStatus.success
                                      //     ? const Padding(
                                      //         padding: EdgeInsets.only(left: 8.0),
                                      //         child: Icon(
                                      //           Icons.check_circle,
                                      //           color: Colors.green,
                                      //         ),
                                      //       )
                                      //     :
                                      (controller.status == FormStatus.error
                                          ? const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 25,
                                            )),
                                ],
                              ),
                            );
                          }),
                    ),
                    group ?? const SizedBox(),
                  ],
                ),
              ),
            ),
            controller.status == FormStatus.error ? errorWidget ?? const SizedBox() : const SizedBox(),
          ],
        ),
      );
    });
  }
}

Widget bottom({
  child,
  Widget? customChild,
  double? maxHeight,
  String? title,
  Color? backgroundTitleColor,
  bool full = false,
  onScreenTap,
  required BuildContext context,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * (maxHeight ?? 1),
                child: GestureDetector(
                  onTap: () {
                    if (onScreenTap != null) {
                      onScreenTap();
                    }
                    final FocusScopeNode currentScope = FocusScope.of(context);
                    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                      FocusManager.instance.primaryFocus!.unfocus();
                    }
                    SystemChrome.restoreSystemUIOverlays();
                  },
                  child: Container(
                    decoration: title == null
                        ? null
                        : BoxDecoration(
                            color: backgroundTitleColor ?? Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25.0),
                              topRight: Radius.circular(25.0),
                            ),
                          ),
                    child: Column(
                      mainAxisSize: full ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title == null
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(title, style: const TextStyle(color: Colors.white)),
                              ),
                        !full
                            ? Flexible(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(bottom: 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Divider(
                                                    thickness: 2,
                                                    indent: MediaQuery.of(context).size.width * 0.35,
                                                    endIndent: MediaQuery.of(context).size.width * 0.35,
                                                  ),
                                                  child ?? const SizedBox(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                  ),
                                  child: SizedBox(
                                    height: (MediaQuery.of(context).size.height * (maxHeight ?? 1)) - 300,
                                    child: customChild ??
                                        SingleChildScrollView(
                                          physics: const BouncingScrollPhysics(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Divider(
                                                  thickness: 2,
                                                  indent: MediaQuery.of(context).size.width * 0.35,
                                                  endIndent: MediaQuery.of(context).size.width * 0.35,
                                                ),
                                                child ?? const SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
