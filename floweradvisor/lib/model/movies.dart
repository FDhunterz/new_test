import 'package:floweradvisor/model/movie.dart';

class MoviesModel{
  List<MovieModel> listmovie;
  int total,page;

  MoviesModel({
    required this.listmovie,
    required this.total,
    required this.page,
  });

}