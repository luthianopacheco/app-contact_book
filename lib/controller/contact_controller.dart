import 'package:contact_list/model/contact_model.dart';
import 'package:contact_list/repository/contact_repository.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  late final ContactRepository _repository;

  ContactController(this._repository);

  List<ContactModel> contactList = <ContactModel>[].obs;

  RxBool isLoading = false.obs;
  RxString imagePath = ''.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getData();
  }

  getData() async {
    isLoading.value = true;

    final response = await _repository.getData();
    contactList.clear();
    contactList.addAll(response);

    isLoading.value = false;
  }

  getDataWhere(String text) async {
    isLoading.value = true;

    final response = await _repository.getData();
    contactList.clear();
    for (var element in response) {
      if (element.name!.contains(text) || element.phone!.contains(text)) {
        contactList.add(element);
      }
    }

    isLoading.value = false;
  }

  createData({
    required String name,
    required String phone,
    required String email,
    required String imagePath,
  }) {
    _repository.createData(ContactModel(
      name: name,
      phone: phone,
      email: email,
      imagePath: imagePath,
    ));
  }

  updateData({
    required String objectId,
    required String name,
    required String phone,
    required String email,
    required String imagePath,
  }) {
    _repository.updateData(ContactModel(
      objectId: objectId,
      name: name,
      phone: phone,
      email: email,
      imagePath: imagePath,
    ));
  }

  deleteData(String objectId) {
    _repository.deleteData(objectId);
  }
}
