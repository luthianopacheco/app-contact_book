import 'package:contact_list/controller/contact_controller.dart';
import 'package:contact_list/repository/contact_repository.dart';
import 'package:get/get.dart';

class ContactBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContactRepository>(() => ContactRepository());
    Get.lazyPut<ContactController>(
        () => ContactController(Get.find<ContactRepository>()),
        fenix: true);
  }
}
