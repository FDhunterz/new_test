import 'package:floweradvisor/controller/movie/dashboard_controller.dart';
import 'package:floweradvisor/controller/movie/detail_controller.dart';
import 'package:floweradvisor/controller/movie/favourite_controller.dart';
import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:floweradvisor/materialx/base_widget.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:floweradvisor/materialx/form.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/view/auth/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:request_api_helper/navigator-helper.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return InitControl(
      child: Fresher<bool>(
        listener: MainController.state.isLoading,
        builder: (vv,ss) {
          final mainController = MainController.state;
          final controller = DashboardController.state;
          final text = mainController.getText();
          return Scaffold(
            body: Fresher(
              listener: controller.refreshers,
              builder: (v,s) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:40,left: 20,right: 20,bottom: 20),
                      child: Row(
                        children: [
                          NoSplashButton(
                            onTap: (){
                              Navigate.push(fadeIn(page: const ProfileView()));
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: mainController.profile?.image == null ? null : DecorationImage(image: NetworkImage(mainController.profile!.image!))
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello, ${mainController.profile?.nama == '' || mainController.profile?.nama == null ? '-' : mainController.profile?.nama }',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(text?.home_subtitle ?? '',
                                  style:  const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          NoSplashButton(
                            onTap: (){
                              FavouriteController.state.route();                        
                            },                        
                            child: const Icon(Icons.favorite)
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialXForm(
                                controller: controller.search,
                                hintText: text?.home_search ?? '',
                                flat: true,
                                onChanged: (d){
                                    replacedFunction(StackFunction(function: (){
                                      controller.getData();
                                    }, id: 1),
                                  );
                                },
                              ),
                            ),
                            NoSplashButton(
                              onTap: (){
                                controller.filter();
                              },
                              child: const Icon(FeatherIcons.sliders)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Expanded(
                      child: v == true? Center(
                        child: SizedBox(
                          width: 100,
                          child: Image.asset('asset/loading.gif')),
                      ) : controller.data == null ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('asset/no-data.gif',width: 50,),
                          const SizedBox(height: 12,),
                          Text(text?.detail_nodata ?? ''),
                        ],
                      ): SingleChildScrollView(
                      controller: controller.scrollController,
                      physics: const BouncingScrollPhysics(),                
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom:20.0),
                            child: Wrap(
                              children: controller.data?.listmovie.map((e) {
                                final getIndex =  controller.data?.listmovie.indexOf(e) ?? 0;
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width * .5,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: getIndex % 2 == 0 ? 12: 0, right: getIndex % 2 == 1 ? 12: 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: GestureDetector(
                                        onTap: (){
                                          DetailController.state.route(e);
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 300,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                image:  DecorationImage(
                                                  image: NetworkImage( e.poster == null || e.poster == 'N/A' ?'https://static.thenounproject.com/png/2932881-200.png' : e.poster!),
                                                  fit: e.poster == null || e.poster == 'N/A' ? BoxFit.contain :BoxFit.cover,
                                                  invertColors: e.poster == null || e.poster == 'N/A' ? true : false,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4,),
                                            Text(
                                              e.title ?? '',maxLines: 2,overflow: TextOverflow.ellipsis,
                                              style:const  TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              e.type ?? '',
                                              style:const  TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white60,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList() ?? [],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
          );
        }
      ),
    );
  }
}