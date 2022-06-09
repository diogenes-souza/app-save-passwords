import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/mensagem.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  //Declaração da coleção de senhas
  var site;
  var url;
  var user;
  var email;
  var password;
  var date;


  @override
  void initState() {
    super.initState();
    app-save-passwords = FirebaseFirestore.instance
        .collection('app-save-passwords')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Salve suas senhas!'),
        centerTitle: true,
        backgroundColor: const Color(0xFF22272D),
        automaticallyImplyLeading: false,
        actions: [
          Column(
            children: [
              IconButton(
                tooltip: 'sair',
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, 'login');
                },
                icon: const Icon(Icons.logout),
              ),

              //
              // RETORNAR O NOME DO USUÁRIO
              //
              FutureBuilder(
                future: retornarUsuarioLogado(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //return const Text('');
                    return const CircularProgressIndicator();
                  } else {
                    return Text(
                      nomeUsuario ?? '',
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),

      backgroundColor: const Color(0xFF22272D)[50],

      body: Container(
        padding: const EdgeInsets.all(50),
        //
        // Exibir os documentos da Coleção
        //
        child: StreamBuilder<QuerySnapshot>(
          //fonte de dados
          stream: app-save-passwords.snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Center(child: Text('Não foi possível conectar.'));
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                final dados = snapshot.requireData;
                return ListView.builder(
                  itemCount: dados.size,
                  itemBuilder: (context, index) {
                    return exibirDocumento(dados.docs[index]);
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF22272D),
        child: const Icon(Icons.add),
        onPressed: () {
          //Navigator.pushNamed(context, 'inserir');
          Navigator.pushNamed(
            context,
            'inserir',
            arguments: {"alterar": true},
          );
        },
      ),
    );
  }

  exibirDocumento(item) {
    String site = item.data()['site'];
    String url = item.data()['url'];
    return ListTile(
      title: Text(site),
      subtitle: Text(url),
      
      // REMOVER UM DOCUMENTO
      // trailing: IconButton(

      //   icon: const Icon(Icons.delete_outline),
      //   onPressed: () {
      //     FirebaseFirestore.instance.collection('app-save-passwords').doc(item.id).delete();

      //     sucesso(context, 'Item removido com sucesso.');
      //   },
      // ), 

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
  
          IconButton(onPressed: () {
            Navigator.pushNamed(
            context,
            'inserir',
            arguments:  {"alterar": true, "id": item.id},
        );
          }, icon: Icon(Icons.edit)),
          
          
          IconButton(onPressed: () {
            FirebaseFirestore.instance.collection('app-save-passwords').doc(item.id).delete();

            sucesso(context, 'Item removido com sucesso.');
          }, icon: Icon(Icons.delete)),
        ],
      ),
  



      //PASSAR COMO ARGUMENTO O id do Café
      onTap: () {
        Navigator.pushNamed(
          context,
          'inserir',
          arguments: {"alterar": false, "id": item.id},
        );
      },
    );
  }

  retornarUsuarioLogado() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .where('uid', isEqualTo: uid)
        .get()
        .then((q) {
      if (q.docs.isNotEmpty) {
        nomeUsuario = q.docs[0].data()['nome'];
      } else {
        nomeUsuario = "NENHUM";
      }
    });
  }
}