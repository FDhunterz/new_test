import 'package:floweradvisor/database/model/data_movie.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/model/movie.dart';
import 'package:floweradvisor/view/movie/favourite.dart';
import 'package:flutter_middleware/controller.dart';
import 'package:request_api_helper/navigator-helper.dart';

class FavouriteController extends Controllers{
  static final state = FavouriteController._state();
  FavouriteController._state();
  List<MovieModel> data = [];

  isFavourite(MovieModel data){
    return this.data.where((element) => element.imdbID == data.imdbID).isNotEmpty;
  }

  save(MovieModel data) async {
    final d= isFavourite(data);
    if(d){
      await DataMovie.delete(data);
    }else{
      await DataMovie.insert(data);
    }
    await getDatabase();
  }

  getDatabase()async {
    final d = await DataMovie.get();
    data.clear();
    for(var i in d){
      final mov = MovieModel.build(i);
      mov.setDetail(i);
      data.add(mov);
    }
  }

  route(){
    Navigate.push(slideRight(page: const FavouriteView()));
  }
}