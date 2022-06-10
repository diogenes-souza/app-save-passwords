import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/mensagem.dart';

class InserirPage extends StatefulWidget {
  const InserirPage({Key? key}) : super(key: key);

  @override
  _InserirPageState createState() => _InserirPageState();
}

class _InserirPageState extends State<InserirPage> {
  var txtSite = TextEditingController();
  var txtURL = TextEditingController();
  var txtUser = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtDate = TextEditingController();
  bool alterar = true;

  //Retonar um documento pelo ID
  retornarDocumentoById(id) async{
    await FirebaseFirestore.instance
      .collection('app_save_passwords')
      .doc(id)
      .get()
      .then((doc){
        txtSite.text = doc.get('site');
        txtURL.text = doc.get('url');
        txtUser.text = doc.get('user');
        txtEmail.text = doc.get('email');
        txtPassword.text = doc.get('password');
        txtDate.text = doc.get('date');
      });
  }

  @override
  Widget build(BuildContext context) {

    //Recuperar o id do Gerenciador
    var data = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    var id = data['id'];
    alterar = data['alterar'];

    print(data);

    if (id!=null){
      if (txtSite.text.isEmpty && txtURL.text.isEmpty){
        retornarDocumentoById(id);
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerencie suas senhas!', style: TextStyle(color:const Color(0xFFD31334), fontSize: 25, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF22272D),
      ),

      backgroundColor: const Color(0xFF22272D),

      body: Container(
        padding: const EdgeInsets.all(50),
        child: ListView(
          children: [
            campoTexto('Site', txtSite, Icons.web, alterar: alterar),
            const SizedBox(height: 20),

            campoTexto('URL', txtURL, Icons.link, alterar: alterar),
            const SizedBox(height: 20),

            campoTexto('Usuário', txtUser, Icons.person, alterar: alterar),
            const SizedBox(height: 20),

            campoTexto('E-mail', txtEmail, Icons.mail, alterar: alterar),
            const SizedBox(height: 20),

            campoTexto('Senha', txtPassword, Icons.password, alterar: alterar),
            const SizedBox(height: 20),

            campoTexto('Data de Atualização', txtDate, Icons.date_range, alterar: alterar),
            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                SizedBox(
                  width: 150,
                  
                
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: const Color(0xFFD31334),
                    ),
                    child: const Text('Salvar'),

                   
                    onPressed: !alterar ? null : () {
                      
                      if ( id == null){
                        //Adicionar um novo documento
                        FirebaseFirestore.instance
                          .collection('app_save_passwords')
                          .add(
                            {
                              "uid" : FirebaseAuth.instance.currentUser!.uid,
                              "site" : txtSite.text,
                              "url": txtURL.text,
                              "user": txtUser.text,
                              "email": txtEmail.text,
                              "password": txtPassword.text,
                              "date": txtDate.text,
                            }
                          );
                        sucesso(context,'Item adicionado com sucesso.');
                      }
                      
                      else{
                        FirebaseFirestore.instance
                          .collection('app_save_passwords')
                          .doc(id.toString())
                          .set(
                            {
                              "uid" : FirebaseAuth.instance.currentUser!.uid,
                              "site" : txtSite.text,
                              "url": txtURL.text,
                              "user": txtUser.text,
                              "email": txtEmail.text,
                              "password": txtPassword.text,
                              "date": txtDate.text,
                            }
                          );
                          sucesso(context,'Item alterado com sucesso.');
                      }

                      Navigator.pop(context);
                    },//onPressed
                     
                  ),
                
                ),

                const SizedBox(width: 10),

                SizedBox(
                  width: 150,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: const Color(0xFFD31334),
                      ),
                      child: const Text('Cancelar'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  campoTexto(texto, controller, icone, {senha,alterar}) {
    return TextField(
      controller: controller,
      obscureText: senha != null ? true : false,
      readOnly: !alterar,
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
}