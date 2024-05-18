import 'package:get/get.dart';

class RoleController extends GetxController {
  RxString role = RxString(''); // Sử dụng RxString để giữ cho biến role có thể reactive
  RxString name = RxString(''); // Sử dụng RxString để giữ cho biến role có thể reactive

  void setRole(String newRole) {
    role.value = newRole;
  }
  void setName(String newName) {
    name.value = newName;
  }
}