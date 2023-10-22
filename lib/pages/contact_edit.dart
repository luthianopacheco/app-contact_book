import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:contact_list/controller/contact_controller.dart';
import 'package:contact_list/model/contact_model.dart';
import 'package:contact_list/shared/utils/formatters.dart';
import 'package:contact_list/shared/widgets/camera_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactEdit extends StatefulWidget {
  final ContactController controller;
  final bool showBackPage;

  const ContactEdit(
      {super.key, required this.controller, this.showBackPage = true});

  @override
  State<ContactEdit> createState() => _ContactEditState();
}

class _ContactEditState extends State<ContactEdit> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _emailController;
  final RxString path = ''.obs;
  int? index;
  ContactModel? item;

  @override
  void initState() {
    super.initState();
    getArgument();
  }

  getArgument() {
    if (widget.showBackPage && Get.arguments != null) {
      index = Get.arguments;
      item = widget.controller.contactList[index!];
      _nameController = TextEditingController(text: item!.name ?? '');
      _phoneController = TextEditingController(text: item!.phone);
      _emailController = TextEditingController(text: item!.email ?? '');

      if (item?.imagePath == '' || item?.imagePath == null) {
        widget.controller.imagePath.value = '';
      } else {
        widget.controller.imagePath.value = item!.imagePath!;
      }
    } else {
      widget.controller.imagePath.value = '';
      _nameController = TextEditingController();
      _phoneController = TextEditingController();
      _emailController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showBackPage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: IconButton(
                        color: Colors.blue,
                        onPressed: () {
                          Get.offAndToNamed('/contactDetails',
                              arguments: index);
                        },
                        icon: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios),
                            Text(
                              'Detalhes',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: widget.showBackPage ? 20 : 40),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context, builder: (context) => const Camera());
                },
                child: Stack(
                  children: [
                    Obx(
                      () => CircleAvatar(
                        backgroundColor: Colors.grey,
                        maxRadius: 70,
                        minRadius: 70,
                        backgroundImage:
                            FileImage(File(widget.controller.imagePath.value)),
                        onBackgroundImageError: (exception, stackTrace) =>
                            debugPrint(exception.toString()),
                        child: editIcon(
                          widget: widget.controller.imagePath.value != ''
                              ? const SizedBox()
                              : !widget.showBackPage
                                  ? const Icon(
                                      Icons.person,
                                      size: 110,
                                      color: Colors.white,
                                    )
                                  : Text(
                                      TextFormatters.initialsName(
                                          item!.name.toString()),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        fontSize: 58,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              customTextField(
                  label: 'Nome',
                  textController: _nameController!,
                  keyboardType: TextInputType.name,
                  capitalization: TextCapitalization.words),
              const SizedBox(height: 20),
              customTextField(
                  label: 'Telefone',
                  textController: _phoneController!,
                  keyboardType: TextInputType.number,
                  formatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ]),
              const SizedBox(height: 20),
              customTextField(
                  label: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  textController: _emailController!,
                  isToValidate: false,
                  formatter: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[,/\\"\[\]\{\}><;:?!#$%&*\(\)=+|\s]'))
                  ]),
              const SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                      width: 100,
                      child: FilledButton(
                          onPressed: () {
                            widget.showBackPage
                                ? Get.offAndToNamed('/contactDetails',
                                    arguments: index)
                                : Get.offAndToNamed('/home');
                          },
                          child: const Text('Cancelar'))),
                  SizedBox(
                      width: 100,
                      child: FilledButton(
                          onPressed: () async {
                            if (widget.showBackPage) {
                              if (formKey.currentState!.validate()) {
                                await widget.controller.updateData(
                                    objectId: item!.objectId!,
                                    name: _nameController!.text,
                                    phone: _phoneController!.text,
                                    email: _emailController!.text,
                                    imagePath:
                                        widget.controller.imagePath.value);
                                await widget.controller.getData();
                                Get.offAndToNamed('/contactDetails',
                                    arguments: index);
                              }
                            } else {
                              if (formKey.currentState!.validate()) {
                                await widget.controller.createData(
                                    name: _nameController!.text,
                                    phone: _phoneController!.text,
                                    email: _emailController!.text,
                                    imagePath:
                                        widget.controller.imagePath.value);

                                Get.offAndToNamed('/home');
                              }
                            }
                            await widget.controller.getData();
                          },
                          child: const Text('Salvar'))),
                ],
              )
            ],
          ),
        )),
      ),
    );
  }

  editIcon({Widget widget = const SizedBox()}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget,
        const Align(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.edit, color: Color.fromARGB(255, 0, 156, 89)),
        )
      ],
    );
  }

  customTextField({
    required String label,
    required TextEditingController textController,
    bool isToValidate = true,
    TextCapitalization capitalization = TextCapitalization.none,
    List<TextInputFormatter>? formatter,
    required TextInputType keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextFormField(
        controller: textController,
        textAlignVertical: TextAlignVertical.top,
        textCapitalization: capitalization,
        keyboardType: keyboardType,
        style: const TextStyle(overflow: TextOverflow.ellipsis),
        inputFormatters: formatter,
        validator: (value) {
          if (value == null || value.isEmpty && isToValidate) {
            return "Campo obrigatório!";
          }
          return null;
        },
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 0, 156, 89),
            ),
          ),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle:
              const TextStyle(color: Color.fromARGB(255, 0, 156, 89)),
          isDense: false,
          contentPadding:
              const EdgeInsets.only(left: 0, top: 8, right: 12, bottom: 0),
        ),
      ),
    );
  }
}
