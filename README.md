#Projeto Lista de Tarefas (To-Do List) com Flutter e Firebase
Este é um projeto de aplicativo de lista de tarefas desenvolvido com Flutter para o front-end e Firebase (Cloud Firestore) para o back-end em nuvem. 
O projeto foi desenvolvido como parte das atividades para a turma de TDS do SENAC Sorocaba.

status do Projeto
✅ Concluído.

Funcionalidades Implementadas
[x] Criação e conexão com banco de dados no Cloud Firestore: O aplicativo está configurado e conectado a um projeto Firebase, 
    utilizando o Firestore para armazenar os dados.

[x] Adição de novas tarefas: Através de um campo de texto, o usuário pode criar novas tarefas que são salvas instantaneamente no banco de dados.

[x] Remoção de tarefas: Cada tarefa na lista possui um botão de exclusão que a remove do banco de dados em tempo real.

[x] Atualização de status das tarefas: Com um simples toque, o status de cada tarefa alterna entre "Pendente", "Em desenvolvimento" e "Concluída".

[x] Estilização da interface: A interface foi aprimorada com widgets do Flutter, incluindo cores e ícones dinâmicos que mudam de acordo com o status da tarefa, 
    melhorando a experiência do usuário.

Tecnologias Utilizadas
Flutter: Framework para desenvolvimento de aplicativos multiplataforma.

Firebase: Plataforma da Google para desenvolvimento de aplicativos.

Cloud Firestore: Banco de dados NoSQL em nuvem para armazenamento de dados em tempo real.

Como Executar o Projeto
Clone este repositório.

Certifique-se de ter o Flutter instalado e configurado no seu ambiente.

Configure a conexão com seu próprio projeto Firebase seguindo as instruções da FlutterFire CLI (flutterfire configure).

Rode o comando flutter pub get no terminal para instalar as dependências.

Execute o aplicativo com flutter run.
