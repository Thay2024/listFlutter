import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //garante que tudo esteja pronto ao carregar
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _listControl = TextEditingController();
  final CollectionReference _list = FirebaseFirestore.instance.collection('tarefas');

  // FUNÇÃO DE ADICIONAR TAREFA (MODIFICADA)
  // Agora também adiciona um status inicial
  Future<void> _addList() async {
    if (_listControl.text.isNotEmpty) {
      await _list.add({
        "titulo": _listControl.text,
        "status": "Pendente", // Status inicial
        "times": Timestamp.now()
      });
      _listControl.clear();
    }
  }

  // NOVA FUNÇÃO PARA DELETAR TAREFA
  Future<void> _deleteTask(String docId) async {
    await _list.doc(docId).delete();
    // Mostra uma confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa removida com sucesso!')),
    );
  }

  // NOVA FUNÇÃO PARA ATUALIZAR O STATUS
  Future<void> _updateStatus(String docId, String currentStatus) async {
    String newStatus;
    // Lógica para ciclar entre os status
    if (currentStatus == "Pendente") {
      newStatus = "Em desenvolvimento";
    } else if (currentStatus == "Em desenvolvimento") {
      newStatus = "Concluída";
    } else {
      newStatus = "Pendente";
    }

    await _list.doc(docId).update({"status": newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        backgroundColor: Colors.deepPurple, // Estilização
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _listControl,
                    decoration: const InputDecoration(
                      labelText: 'Nova Tarefa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  style: IconButton.styleFrom(backgroundColor: Colors.deepPurple),
                  icon: const Icon(Icons.add),
                  onPressed: _addList,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _list.orderBy('times', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];

                      // Lógica para estilização baseada no status
                      Color cardColor = Colors.white;
                      IconData statusIcon = Icons.help_outline;
                      if (documentSnapshot['status'] == 'Concluída') {
                        cardColor = Colors.green.shade100;
                        statusIcon = Icons.check_circle_outline;
                      } else if (documentSnapshot['status'] == 'Em desenvolvimento') {
                        cardColor = Colors.orange.shade100;
                        statusIcon = Icons.rocket_launch_outlined;
                      }

                      return Card(
                        color: cardColor, // Cor de fundo do card
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: ListTile(
                          // Adiciona um ícone na frente que representa o status
                          leading: Icon(statusIcon, color: Colors.deepPurple),
                          
                          // Título da tarefa
                          title: Text(
                            documentSnapshot['titulo'],
                            style: TextStyle(
                              // Tacha o texto se a tarefa estiver concluída
                              decoration: documentSnapshot['status'] == 'Concluída'
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          // Subtítulo mostrando o status
                          subtitle: Text(documentSnapshot['status']),
                          
                          // Ação de clique para ATUALIZAR
                          onTap: () => _updateStatus(
                            documentSnapshot.id,
                            documentSnapshot['status'],
                          ),

                          // Botão no final para DELETAR
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _deleteTask(documentSnapshot.id),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}