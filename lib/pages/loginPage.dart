import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'widgets/mensagem.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      // appBar: AppBar(
      //   title: const Text('Bem vindo, Salve suas senhas!'),
      //   centerTitle: true,
      //   backgroundColor: const Color(0xFF22272D),
      // ),

      backgroundColor: const Color(0xFF22272D), //#22272D
      
      body: Container(
        padding: const EdgeInsets.all(90),
        child: ListView
        (
          children: [

            campoTexto('Email', txtEmail, Icons.email),
            const SizedBox(height: 20),

            campoTexto('Senha', txtSenha, Icons.lock, senha: true),
            const SizedBox(height: 10),

            TextButton(onPressed: (){}, child: const Text('Esqueceu a senha?', textAlign: TextAlign.end,)),
            const SizedBox(height: 30),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                minimumSize: const Size(200, 45),
                backgroundColor: const Color(0xFFD31334),
              ),
              child: const Text('ENTRAR'),
              onPressed: () {
                login(txtEmail.text, txtSenha.text);
              },
            ),

            const SizedBox(height: 20),

            // OutlinedButton(
            //   style: OutlinedButton.styleFrom(
            //     primary: Colors.white,
            //     minimumSize: const Size(200, 45),
            //     backgroundColor: Colors.grey,
            //   ),
            //   child: const Text('entrar'),
            //   onPressed: () {
            //     login(txtEmail.text, txtSenha.text);
            //   },
            // ),

            const SizedBox(height: 40),
            TextButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white, //#D31334
              ),
              child: const Text('Criar conta?'),
              onPressed: () {
                Navigator.pushNamed(context, 'criar_conta');
              },
            ),

          ],
        ),
      ),
    );
  }

  //
  // CAMPO DE TEXTO
  //
  campoTexto(texto, controller, icone, {senha}) {
    return TextField(
      controller: controller,
      obscureText: senha != null ? true : false,
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icone, color: Colors.grey),
        prefixIconColor: Colors.grey,
        labelText: texto,
        labelStyle: const TextStyle(color: Colors.grey),
        border: const OutlineInputBorder(),
        focusColor: Colors.grey,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0.0,
          ),
        ),
      ),
    );
  }

  //
  // LOGIN com Firebase Auth
  //
  void login(email, senha) {
    FirebaseAuth.instance
    .signInWithEmailAndPassword(email: email, password: senha)
    .then((res){
      sucesso(context, 'Usuário autenticado com sucesso.');
      Navigator.pushReplacementNamed(context, 'principal');
    }).catchError((e){
      switch(e.code){
        case 'invalid-email':
          erro(context,'O formato do email é inválido.');
          break;
        case 'user-not-found':
          erro(context,'Usuário não encontrado.');
          break;
        case 'wrong-password':
          erro(context,'Senha incorreta.');
          break;
        default:
          erro(context,e.code.toString());
      }
   });
   }
}