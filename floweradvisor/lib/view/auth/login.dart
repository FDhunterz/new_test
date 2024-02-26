import 'package:floweradvisor/controller/auth/login_controller.dart';
import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:floweradvisor/materialx/base_widget.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:floweradvisor/materialx/form.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = LoginController.state;
    final text = MainController.state.getText();
    return InitControl(
      child: Fresher(
        listener: controller.refreshers,
        builder: (v,s) {
          return Scaffold(
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                       Text(text?.login_title ?? '',
                          style:
                              const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                       Text(
                        text?.login_subtitle ?? '',
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialXForm(
                        title: text?.login_form_user ?? '',
                        hintText: text?.login_form_user_hint ?? '',
                        controller: controller.userController!,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      MaterialXForm(
                        title: text?.login_password ?? '',
                        hintText: text?.login_password_hint ?? '',
                        controller: controller.passwordController!,
                        obsecure: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      MaterialXButton(
                        onTap: () {
                          controller.login();
                        },
                        title: text?.login_title ?? '',
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}
