import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/model/movie.dart';
import 'package:floweradvisor/view/movie/detail.dart';
import 'package:flutter_middleware/controller.dart';
import 'package:request_api_helper/helper/map_builder.dart';
import 'package:request_api_helper/navigator-helper.dart';
import 'package:request_api_helper/request_api_helper.dart';

class DetailController extends Controllers{
  static final state = DetailController._state();
  List dataShow = [];
  DetailController._state();

  MovieModel? selectedData;

  renderDataShow(){
    final text = MainController.state.getText();
    dataShow = [
      {'title' : 'Genre', 'value' : selectedData!.genre},
      {'title' : text?.detail_actors, 'value' : selectedData!.actors},
      {'title' : text?.detail_production, 'value' : selectedData!.production},
      {'title' : text?.detail_awards, 'value' : selectedData!.awards},
      {'title' : text?.detail_boxoffice, 'value' : selectedData!.boxoffice},
      {'title' : text?.detail_country, 'value' : selectedData!.country},
      {'title' : text?.detail_director, 'value' : selectedData!.director},
      {'title' : text?.detail_imdbRating, 'value' : selectedData!.imdbRating},
      {'title' : text?.detail_imdbVotes, 'value' : selectedData!.imdbVotes},
      {'title' : text?.detail_languange, 'value' : selectedData!.languange},
      {'title' : text?.detail_metascore, 'value' : selectedData!.metaScore},
      {'title' : text?.detail_rated, 'value' : selectedData!.rated},
      {'title' : text?.detail_released, 'value' : selectedData!.released},
    ];
  }

  getData(MovieModel data) async {
    
    MainController.state.start();
    final api = API();
    api.url = '';
    api.body = {
      'apikey' : 'd9dedfa6',
      'i' : data.imdbID
    };

    api.onSuccess =   (d)async{
      final dd = await d.convert();
      MapBuilder.show(dd);
      data.setDetail(dd);
      selectedData = data;
      Navigate.push(slideRight(page: const DetailView()));
      MainController.state.end();
    };

    await api.get();
  }

  route(MovieModel data,{MovieModel? haveAllData}){
    if(haveAllData != null){
      selectedData = haveAllData;
      Navigate.push(slideRight(page: const DetailView()));
    }else{
      getData(data);
    }
  }

  dispose(){

  }
}