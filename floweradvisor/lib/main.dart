import 'dart:async';

import 'package:floweradvisor/controller/movie/favourite_controller.dart';
import 'package:floweradvisor/database/model/data_movie.dart';
import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_middleware/flutter_middleware.dart';
import 'package:request_api_helper/global_env.dart';
import 'package:sql_query/builder/query_builder.dart' as sql;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ENV.config.save(
    ENVData(
      baseUrl: 'http://www.omdbapi.com/',
      onException: (exception) async {
        print(exception);
      },
    ),
  );
  
  await sql.DB.init(
    databaseName: 'sesuatu',
    tableList: [
      DataMovie.tables(),
    ],
  );
  FavouriteController.state.getDatabase();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

  Middleware.state.set($navigatorKey: ENV.navigatorKey, $middlewares: []);
  Future.delayed(Duration.zero,() async{
    await MainController.state.initial();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mainc = MainController.state;
    return Fresher<bool>(
      listener: mainc.isLoading,
      builder: (v,s) {
        return MaterialApp(
          localizationsDelegates: mainc.localizationsDelegates() ,
          supportedLocales: mainc.supportedLocales(),
          navigatorKey: ENV.navigatorKey,
          locale: mainc.locale,
          title: 'Faizal Movie Apps',
          theme: ThemeData.dark(useMaterial3: true),
          home: const Scaffold(),
        );
      }
    );
  }
}
