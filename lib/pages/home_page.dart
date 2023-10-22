import 'dart:io';

import 'package:contact_list/controller/contact_controller.dart';
import 'package:contact_list/pages/contact_edit.dart';
import 'package:contact_list/shared/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final ContactController controller;
  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contatos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              color: const Color.fromARGB(255, 0, 156, 89),
              iconSize: 30,
              tooltip: 'Adicionar Contato',
              onPressed: () {
                Get.to(ContactEdit(
                  showBackPage: false,
                  controller: widget.controller,
                ));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.top,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 0, 156, 89)),
                        borderRadius: BorderRadius.circular(30)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: 'Buscar',
                    isDense: false,
                    contentPadding: const EdgeInsets.only(
                        left: 0, top: 8, right: 12, bottom: 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      widget.controller.getDataWhere(value);
                    } else {
                      widget.controller.getData();
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => widget.controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => widget.controller.getData(),
                        child: ListView.builder(
                          itemCount: widget.controller.contactList.length,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemBuilder: (context, index) {
                            final item = widget.controller.contactList[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    maxRadius: 25,
                                    backgroundImage: FileImage(
                                        File(item.imagePath.toString())),
                                    onBackgroundImageError:
                                        (exception, stackTrace) =>
                                            debugPrint(exception.toString()),
                                    child: item.imagePath != ''
                                        ? const SizedBox()
                                        : Text(
                                            TextFormatters.initialsName(
                                                item.name.toString()),
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                  title: Text(item.name.toString()),
                                  subtitle: Text(item.phone.toString()),
                                  onTap: () {
                                    Get.toNamed('/contactDetails',
                                        arguments: index);
                                  },
                                ),
                                const Divider(thickness: 1)
                              ],
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
