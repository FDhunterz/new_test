import 'dart:ffi';

import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:floweradvisor/materialx/button.dart';
import 'package:floweradvisor/materialx/form.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/materialx/toast.dart';
import 'package:floweradvisor/model/movie.dart';
import 'package:floweradvisor/model/movies.dart';
import 'package:floweradvisor/view/movie/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_middleware/controller.dart';
import 'package:request_api_helper/global_env.dart';
import 'package:request_api_helper/helper/map_builder.dart';
import 'package:request_api_helper/navigator-helper.dart';
import 'package:request_api_helper/request_api_helper.dart';

class DashboardController extends Controllers{
  late Fresh refreshers;
  MoviesModel? data;
  late MaterialXFormController search,year;
  List<String> filterActive = [];
  static final state = DashboardController._state();
  late ScrollController scrollController; 
  void Function()? nextFunction;
  DashboardController._state();


  __construct(){
    search = MaterialXFormController(prefix: const Padding(
      padding:  EdgeInsets.only(right: 12),
      child:  Icon(Icons.search),
    ),);
    year = MaterialXFormController();
    refreshers = Fresh(null);
    scrollController = ScrollController();
    nextFunction = () {
      if((data?.listmovie.length ?? 0) >= (data?.total ?? 0)){
        return;
      }
      if(!MainController.state.isLoading.value){
        if(scrollController.offset > scrollController.position.maxScrollExtent - 400){
          MainController.state.start();
          getData(nextData: true);
        }
      }
    };
    scrollController.addListener(nextFunction!);
  }


  getData({nextData = false})async {
    if(!nextData){
      refreshers.refresh((listener) => listener.value = true);
    }
    final api = API();
    api.url = '';
    
    api.body ={
      'apikey' : 'd9dedfa6',
      's' : search.controller!.text == '' ?  'a' : search.controller!.text,
      'y' : year.controller!.text ,
    };

    if(filterActive.isNotEmpty){
      api.body?.addAll({'type' : filterActive.first});
    }

    if(nextData){
      api.body?.addAll({'page' : data!.page + 1});
    }

    api.replacementId = 'get_data';
    api.withLoading = false;
    api.onSuccess = (d)async {
      final dd = await d.convert();
      MapBuilder.show(dd);        
      if(dd['Error'] != null){
        refreshers.refresh((listener) => listener.value = null);
        showToast(title: 'Error',message: dd['Error']);
        return;
      }
      final List<MovieModel> list = [];
      for(var i in dd['Search']){
        list.add(MovieModel.build(i));
      }
      if(nextData){
        data!.listmovie.insertAll(data!.listmovie.length,list);
        ++data!.page;
        MainController.state.end();
      }else{
        data = MoviesModel(listmovie: list, total: int.parse(dd['totalResults']), page: 1);
      }
      refreshers.refresh((listener) => listener.value = null);
    };
    api.onError = (d)async {
      final dd = await d.convert();
      
    };
    await api.get();
  }

  filter() async {
    bool changed = false;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: ENV.navigatorKey.currentContext!, 
      builder: (context){
        return bottom(
          context: context,
          child: StatefulBuilder(
            builder: (context,s) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(MainController.state.getText()?.home_filter ?? '',
                    style:const TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MaterialXButton(
                        color: filterActive.where((element) => element == 'Movie').isNotEmpty ? null: Colors.white10,
                        textColor: filterActive.where((element) => element == 'Movie').isNotEmpty ? null : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        onTap: (){
                          changed = true;
                          if(filterActive.where((element) => element == 'Movie').isNotEmpty){
                            filterActive.remove('Movie');
                          }else{
                            filterActive.clear();
                            filterActive.add('Movie');
                          }
                          s((){});
                        },
                        title: 'Movie',
                      ),
                      const SizedBox(width: 12,),
                      MaterialXButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        color: filterActive.where((element) => element == 'Series').isNotEmpty ? null: Colors.white10,
                        textColor: filterActive.where((element) => element == 'Series').isNotEmpty ? null : Colors.white,
                        onTap: (){
                          changed = true;
                          filterActive.clear();
                          if(filterActive.where((element) => element == 'Series').isNotEmpty){
                            filterActive.remove('Series');
                          }else{
                            filterActive.clear();
                            filterActive.add('Series');
                          }
                          s((){});
                        },
                        title: 'Series',
                      ),
                      const SizedBox(width: 12,),
                      MaterialXButton(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        color: filterActive.where((element) => element == 'Episode').isNotEmpty ? null: Colors.white10,
                        textColor: filterActive.where((element) => element == 'Episode').isNotEmpty ? null : Colors.white,
                        onTap: (){
                          changed = true;
                          if(filterActive.where((element) => element == 'Episode').isNotEmpty){
                            filterActive.remove('Episode');
                          }else{
                            filterActive.clear();
                            filterActive.add('Episode');
                          }
                          s((){});
                        },
                        title: 'Episode',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12,),
                  MaterialXForm(
                    title: MainController.state.getText()?.home_year ?? '',
                    controller: year,
                    isNumber: true,
                    onChanged: (d) async {
                          changed = true;
                      s((){});
                    },
                    
                  ),
                ],
              );
            }
          )
        );
      },
    );
    if(changed){
      getData();
    }
    
  }

  route(){
  __construct();
  getData();
  Navigate.pushAndRemoveUntil(slideRight(page: const HomeView())).then((d) => dispose());
  }

  dispose(){
  scrollController.removeListener(nextFunction!);
  search.dispose();
  year.dispose();
  refreshers.dispose();
  scrollController.dispose();

  }
}