import 'package:contact_list/binding/contact_binding.dart';
import 'package:contact_list/controller/contact_controller.dart';
import 'package:contact_list/pages/contact_details_page.dart';
import 'package:contact_list/pages/contact_edit.dart';
import 'package:contact_list/pages/home_page.dart';
import 'package:contact_list/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            centerTitle: true,
            shadowColor: const Color.fromARGB(255, 0, 156, 89),
            titleTextStyle: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: const Color.fromARGB(255, 0, 156, 89)),
          ),
          filledButtonTheme: const FilledButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 0, 156, 89))))),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      initialBinding: ContactBinding(),
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(
            name: '/home',
            page: () => HomePage(controller: Get.find<ContactController>()),
            binding: ContactBinding()),
        GetPage(
            name: '/contactDetails',
            page: () =>
                ContactDetails(controller: Get.find<ContactController>()),
            binding: ContactBinding()),
        GetPage(
            name: '/contactEdit',
            page: () => ContactEdit(controller: Get.find<ContactController>()),
            binding: ContactBinding()),
      ],
    );
  }
}
