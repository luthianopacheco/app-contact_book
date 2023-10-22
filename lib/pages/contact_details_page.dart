import 'dart:io';

import 'package:contact_list/controller/contact_controller.dart';
import 'package:contact_list/pages/home_page.dart';
import 'package:contact_list/shared/utils/formatters.dart';
import 'package:contact_list/shared/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDetails extends StatefulWidget {
  final ContactController controller;
  ContactDetails({super.key, required this.controller});

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  final index = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final item = widget.controller.contactList[index];
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 100,
                child: IconButton(
                  color: Colors.blue,
                  onPressed: () {
                    Get.to(HomePage(controller: Get.find()));
                  },
                  icon: const Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Text(
                        'Contatos',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Get.offAndToNamed('/contactEdit', arguments: index);
                  },
                  child: const Text('Editar'))
            ],
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: Colors.grey,
            maxRadius: 70,
            minRadius: 70,
            backgroundImage: FileImage(File(item.imagePath.toString())),
            onBackgroundImageError: (exception, stackTrace) =>
                debugPrint(exception.toString()),
            child: item.imagePath.toString() != ''
                ? const SizedBox()
                : Text(
                    TextFormatters.initialsName(item.name.toString()),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 58,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              item.name.toString(),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 20),
          customTextFiel('Telefone', item.phone.toString()),
          const SizedBox(height: 15),
          customTextFiel('E-mail', item.email.toString()),
          const SizedBox(height: 30),
          InkWell(
            onTap: () {},
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.share, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Compartilhar contato',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                )
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          InkWell(
            onTap: () {
              Get.dialog(CustomAlertDialog(
                  name: item.name.toString(),
                  function: () async {
                    await widget.controller.deleteData(item.objectId!);
                    await widget.controller.getData();

                    Get.toNamed('/home');
                  }));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Excluir contato',
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40)
        ],
      ),
    ));
  }

  customTextFiel(String label, String textValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(
            textValue,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          const Divider(thickness: 1)
        ],
      ),
    );
  }
}
