import 'package:floweradvisor/controller/auth/login_controller.dart';
import 'package:floweradvisor/materialx/form.dart';
import 'package:floweradvisor/materialx/toast.dart';
import 'package:flutter_middleware/flutter_middleware.dart';

class LoginRules extends FlutterMiddleware {
  @override
  Future<bool> check(RequestData data) async {
    if (MaterialXFormController.check(data.data)) {
      final controllers = data.data as List<MaterialXFormController?>;
      if (controllers[0]?.controller?.text == 'aldmic' && controllers[1]?.controller?.text == '123abc123') {
        return true;
      } else {
        controllers[0]?.status = FormStatus.error;
        controllers[1]?.status = FormStatus.error;
        showToast(
          message: 'username dan password tidak sesuai ',
          title: 'Error',
        );
      }
      LoginController.state.refresh();
    } else {
      LoginController.state.refresh();
    }
    return false;
  }

  @override
  Future<void> onException(data, functionInfo) {
    throw Exception(
        '\nMiddleware class : $this\nMiddleware Function : $functionInfo\nError Description: $data');
  }
}
