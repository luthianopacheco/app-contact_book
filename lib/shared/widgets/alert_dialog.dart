import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class CustomAlertDialog extends GetView {
  final String name;
  Function()? function;
  CustomAlertDialog({super.key, required this.name, this.function});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: RichText(
          text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 17),
              text: 'Você tem certeza que deseja excluir ',
              children: [
            TextSpan(
                text: '"$name"',
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const TextSpan(text: ' da sua lista de contatos?')
          ])),
      title: const Text('Excluir contato'),
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20)),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
        TextButton(
            onPressed: function,
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
  }
}
