import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/mensagem.dart';

class CriarContaPage extends StatefulWidget {
  const CriarContaPage({Key? key}) : super(key: key);

  @override
  _CriarContaPageState createState() => _CriarContaPageState();
}

class _CriarContaPageState extends State<CriarContaPage> {
  var txtNome = TextEditingController();
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Café Store'),
          centerTitle: true,
          backgroundColor: const Color(0xFF22272D)),
      backgroundColor: const Color(0xFF22272D),
      body: Container(
        padding: const EdgeInsets.all(50),
        child: ListView(
          children: [
            campoTexto('Nome', txtNome, Icons.people),
            const SizedBox(height: 20),
            campoTexto('Email', txtEmail, Icons.email),
            const SizedBox(height: 20),
            campoTexto('Senha', txtSenha, Icons.lock, senha: true),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: const Size(200, 45),
                      backgroundColor: const Color(0xFF22272D),
                    ),
                    child: const Text('criar'),
                    onPressed: () {
                      criarConta(txtNome.text, txtEmail.text, txtSenha.text);
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      minimumSize: const Size(200, 45),
                      backgroundColor: const Color(0xFF22272D),
                    ),
                    child: const Text('cancelar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  campoTexto(texto, controller, icone, {senha}) {
    return TextField(
      controller: controller,
      obscureText: senha != null ? true : false,
      style: const TextStyle(
        color: const Color(0xFF22272D),
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icone, color: const Color(0xFF22272D)),
        prefixIconColor: const Color(0xFF22272D),
        labelText: texto,
        labelStyle: const TextStyle(color: const Color(0xFF22272D)),
        border: const OutlineInputBorder(),
        focusColor: const Color(0xFF22272D),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFF22272D),
            width: 0.0,
          ),
        ),
      ),
    );
  }

  //
  // CRIAR CONTA no Firebase Auth
  //
  void criarConta(nome, email, senha) {
    FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: email, password: senha)
      .then((res){

        //Armazenar o nome no Firestore
        FirebaseFirestore.instance.collection('usuarios')
          .add(
            {
              "uid" : res.user!.uid.toString(),
              "nome" : nome,
            }
          );


        sucesso(context,'Usuário criado com sucesso.');
        Navigator.pop(context);
      }).catchError((e){
        switch(e.code){
          case 'email-already-in-use':
            erro(context,'O email já foi cadastrado.');
            break;
          case 'invalid-email':
            erro(context,'O email é inválido.');
            break;
          default:
            erro(context, e.code.toString());
        }
      });
  }

}