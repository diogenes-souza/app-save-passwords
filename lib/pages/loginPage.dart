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
      
      appBar: AppBar(
        title: const Text('Gerenciador de Senhas!', style: TextStyle(color:const Color(0xFFD31334), fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF22272D),
      ),

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

            //TextButton(onPressed: (){}, child: const Text('Esqueceu a senha?', textAlign: TextAlign.end,)),
            TextButton(
              style: OutlinedButton.styleFrom(
                primary: const Color(0xFFD31334), //#D31334
              ),
              child: const Text('Esqueceu a senha?', textAlign: TextAlign.end, style: TextStyle(fontSize: 12)),
              onPressed: () {
               
              },  
            ),

            const SizedBox(height: 30),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                minimumSize: const Size(200, 45), 
                backgroundColor: const Color(0xFFD31334),
              ),
              child: const Text('Entrar'),
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
                primary: const Color(0xFFD31334), //#D31334
              ),
              child: const Text('Criar conta?', style: TextStyle(fontSize: 18)),
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
        color: const Color(0xFFD31334),
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icone, color: const Color(0xFFD31334)),
        prefixIconColor: const Color(0xFFD31334),
        labelText: texto,
        labelStyle: const TextStyle(color: const Color(0xFFD31334)),
        border: const OutlineInputBorder(),
        focusColor: const Color(0xFFD31334),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFD31334),
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