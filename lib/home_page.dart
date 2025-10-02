import 'package:flutter/material.dart';
import 'package:listflutter/models/task.dart';
import 'package:listflutter/services/firestore_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instância do nosso serviço do Firestore
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder<List<Task>>(
        // O stream que vamos "ouvir" para pegar as tarefas
        stream: firestoreService.getTasks(),
        builder: (context, snapshot) {
          // Se a conexão estiver esperando por dados, mostramos um indicador de progresso
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se houver algum erro, mostramos uma mensagem
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          // Se não houver dados, mostramos uma mensagem para o usuário
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa adicionada.'));
          }

          // Se tudo estiver certo, pegamos a lista de tarefas
          final tasks = snapshot.data!;

          // E construímos uma lista com elas
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                 key: ValueKey(task.id), // Chave única para cada item da lista
                title: Text(
                  task.title,
                  style: TextStyle(
                    // Se a tarefa estiver concluída, a gente risca o texto
                    decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                    fontStyle: task.isCompleted ? FontStyle.italic : FontStyle.normal,
                    color: task.isCompleted ? Colors.grey : Colors.black,
                  ),
                ),
                // Aqui vamos adicionar os botões nos próximos passos
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Exemplo de um Checkbox que vamos usar no próximo passo
                    Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? newValue) {
                        // Vamos implementar a lógica de atualização aqui
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // Aqui vamos adicionar o botão para adicionar tarefas
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Vamos implementar a navegação para a tela de adicionar tarefa aqui
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}