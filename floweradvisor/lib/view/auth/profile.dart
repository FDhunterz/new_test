import 'package:floweradvisor/controller/auth/login_controller.dart';
import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/base_widget.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/view/auth/about_us.dart';
import 'package:flutter/material.dart';
import 'package:request_api_helper/helper/session.dart';
import 'package:request_api_helper/navigator-helper.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context,s) {
      final mainController = MainController.state;
      final text = mainController.getText();
        return InitControl(
          child: Scaffold(
            body: Column(
              children: [
                const Center(),
                const SizedBox(height: 60,),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: mainController.profile?.image == null ? null : DecorationImage(image: NetworkImage(mainController.profile!.image!))
                  ),
                ),
                const SizedBox(height: 12,),
                Text('${mainController.profile?.nama == '' || mainController.profile?.nama == null ? '-' : mainController.profile?.nama }',
                  style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12,),
                Text(text?.login_form_user ?? '',style: const TextStyle(fontWeight: FontWeight.w700),),
                const Text('aldmic'),
                const SizedBox(height: 12,),
                Text(text?.login_password ?? '',style: const TextStyle(fontWeight: FontWeight.w700),),
                const Text('123abc123'),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(text?.detail_languange ?? ''),
                      ),
                       MaterialXButton(
                        onTap: ()async {
                          await mainController.changeLanguage('en');
                          s((){});
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        color: text?.localeName == 'en' ? null:Colors.transparent,
                        title: 'English',
                      ),
                      const SizedBox( width: 12,),
                       MaterialXButton(
                        onTap: ()async {
                          await mainController.changeLanguage('id');
                          s((){});
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        color: text?.localeName == 'id' ? null:Colors.transparent,
                        title: 'Indonesia',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                
                Padding(
                  padding:  const EdgeInsets.all(12.0),
                  child:  MaterialXButton(
                    onTap: (){
                      Navigate.push(fadeIn(page: const AboutUs()));
                    },
                    color: Colors.transparent,
                    title: text?.aboutus ?? '',
                  ),
                ),
                Padding(
                  padding:  const EdgeInsets.all(12.0),
                  child:  MaterialXButton(
                    onTap: (){
                      Session.delete(nameList: ['auth_login']);
                      LoginController.state.route();
                    },
                    color: Colors.red,
                    title: text?.logout ?? '',
                  ),
                )
            
              ],
            ),
          ),
        );
      }
    );
  }
}