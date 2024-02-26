import 'package:floweradvisor/controller/movie/dashboard_controller.dart';
import 'package:floweradvisor/materialx/auto_model.dart';
import 'package:floweradvisor/materialx/form.dart';
import 'package:floweradvisor/materialx/router_animation.dart';
import 'package:floweradvisor/middleware/auth/login_rules.dart';
import 'package:floweradvisor/view/auth/login.dart';
import 'package:flutter_middleware/controller.dart';
import 'package:request_api_helper/helper/session.dart';
import 'package:request_api_helper/navigator-helper.dart';

class LoginController extends Controllers {
  late Fresh refreshers;
  static final state = LoginController._state();
  LoginController._state();
  MaterialXFormController? userController, passwordController;

  refresh() {
    refreshers.refresh((listener) => null);
  }

  __construct() {
    refreshers = Fresh(null);
    userController = MaterialXFormController();
    passwordController = MaterialXFormController();
  }

  route() async {
    __construct();
    await Navigate.push(slideRight(page: const LoginView()));
    dispose();
  }

  // process function

  login() async {
    await call(
      (data) {
        Session.save(header: 'auth_login', boolData: true);
        Session.save(header: 'auth_nama', stringData: 'Me');
        DashboardController.state.route();
      },
      useCustomMiddlewares: [LoginRules()],
      data: [userController!, passwordController!],
      disableGlobalMiddleware: false,
    );
  }

  // end process function

  dispose() {
    refreshers.dispose();
    userController?.dispose();
    passwordController?.dispose();
  }
}
