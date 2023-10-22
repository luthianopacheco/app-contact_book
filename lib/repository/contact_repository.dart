import 'package:contact_list/model/contact_model.dart';
import 'package:dio/dio.dart';

class ContactRepository {
  final _dio = Dio();

  ContactRepository() {
    _dio.options.headers["X-Parse-Application-Id"] =
        "tKJHUsiBi7KPNgUBUBRpxV53EYwEQ7HK4yyqCQUf";
    _dio.options.headers["X-Parse-REST-API-Key"] =
        "0PA1nlw7MMme0dtKj1tCPVjkem16YeWyzBOFhfEd";
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.options.baseUrl = 'https://parseapi.back4app.com/classes';
  }

  Future<List<ContactModel>> getData() async {
    try {
      final response = await _dio.get('/contact');
      final data = response.data['results'];
      return data.map<ContactModel>((e) => ContactModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ContactModel>> getDataWhere(String text) async {
    try {
      final response = await _dio.get('/contact?where={"name": "$text"}');
      print(response.statusCode);
      final data = response.data['results'];
      print(data);
      return data.map<ContactModel>((e) => ContactModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createData(ContactModel contactModel) async {
    try {
      await _dio.post("/contact", data: contactModel.toJsonSimplified());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateData(ContactModel contactModel) async {
    try {
      await _dio.put("/contact/${contactModel.objectId}",
          data: contactModel.toJsonSimplified());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteData(String objectId) async {
    try {
      await _dio.delete("/contact/$objectId");
    } catch (e) {
      rethrow;
    }
  }
}
