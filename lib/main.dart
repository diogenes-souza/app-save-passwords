import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'pages/criarContaPage.dart';
import 'pages/inserirPage.dart';
import 'pages/loginPage.dart';
import 'pages/principalPage.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      // theme: ThemeData(
      //   scaffoldBackgroundColor: const Color(0xFFD31334),
      // ),
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Senhas',
      initialRoute: 'login',
      routes: {
        'login' :(context) => const LoginPage(),
        'criar_conta' :(context) => const CriarContaPage(),
        'principal' :(context) => const PrincipalPage(),

        'inserir': (context) => const InserirPage(),

      },
    ),
  );
}