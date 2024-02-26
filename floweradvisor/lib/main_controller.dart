import 'package:floweradvisor/controller/movie/dashboard_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:floweradvisor/middleware/auth/session_rules.dart';
import 'package:floweradvisor/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_middleware/controller.dart';
import 'package:request_api_helper/global_env.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:request_api_helper/helper/session.dart';

class MainController extends Controllers {
  static final state = MainController._state();
  ProfileModel? profile;
  Locale? locale ;
  MainController._state();
  Fresh<bool> isLoading = Fresh(false);
  start(){
    isLoading.refresh((listener) => listener.value = true);
  }

  end(){
    isLoading.refresh((listener) => listener.value = false);
  }

  AppLocalizations? getText() => AppLocalizations.of(ENV.navigatorKey.currentContext!)!;
  List<LocalizationsDelegate<dynamic>> localizationsDelegates() =>
      AppLocalizations.localizationsDelegates;
  List<Locale> supportedLocales() => AppLocalizations.supportedLocales;

  changeLanguage(code){
    locale = Locale(code);
    Session.save(header: 'locale', stringData: code);
    isLoading.refresh((listener) => null);
  }

  setSession(ProfileModel profile){
    this.profile =profile; 
  }

  initial() async {
    final local = await Session.load('locale');
    if(local != null){
      locale = Locale(local);
    }
    isLoading.refresh((listener) => null);
    await call(
      () {
        DashboardController.state.route();
      },
      useCustomMiddlewares: [SessionRules()],
      disableGlobalMiddleware: false,
    );
  }
}
