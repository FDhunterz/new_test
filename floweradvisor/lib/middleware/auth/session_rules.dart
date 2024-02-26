import 'package:floweradvisor/controller/auth/login_controller.dart';
import 'package:floweradvisor/main_controller.dart';
import 'package:floweradvisor/model/profile.dart';
import 'package:flutter_middleware/flutter_middleware.dart';
import 'package:request_api_helper/helper/session.dart';

class SessionRules extends FlutterMiddleware {
  @override
  Future<bool> check(RequestData data) async {
    final data = await Session.load('auth_login');
    if (data == true) {
      final nama = await Session.load('auth_nama');
      final image = await Session.load('auth_image');
      MainController.state.setSession(ProfileModel(
        nama: nama,
        image: image,
      ));
      return true;
    }
    return false;
  }

  @override
  Future<void> denied(RequestData data) async {
    stop = true;
  }

  @override
  Future<void> onStop(RequestData data) async {
    LoginController.state.route();
  }

  @override
  Future<void> onException(data, functionInfo) {
    throw Exception(
        '\nMiddleware class : $this\nMiddleware Function : $functionInfo\nError Description: $data');
  }
}
