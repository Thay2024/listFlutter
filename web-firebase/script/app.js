const firebaseConfig = {
    apiKey: "AIzaSyDpfBq-P2ZR7l395qUqFnGVKw15k_deci0",
    authDomain: "pwa-notificacao.firebaseapp.com",
    databaseURL: "https://pwa-notificacao-default-rtdb.firebaseio.com",
    projectId: "pwa-notificacao",
    storageBucket: "pwa-notificacao.firebasestorage.app",
    messagingSenderId: "182138961514",
    appId: "1:182138961514:web:206b80101b9d4c518e5413",
    measurementId: "G-GH3JZJK982"
};

firebase.initializeApp(firebaseConfig);
const database = firebase.database();

const form = document.getElementById('data-form');
const name = document.getElementById('name');
const email = document.getElementById('email');
const id_user = document.getElementById('id-user');
const list = document.getElementById('list-user');

const resetFormulario = ()=>{
    name.value = '';
    email.value = '';
    id_user.value = '';
}
form.addEventListener('submit', (event) =>{
    event.preventDefault;
    console.log('teste');

    const id = id_user.value;
    const name_user = name.value;
    const email_user = email.value;

    if(id){
        database.ref('user/' + id).update({
            name: name_user,
            email: email_user
        }).then(() =>{
            console.log('Dados atualizados com sucesso!');
         
        }).catch((error)=>{
            console.error('Erro ao atualizar os dados', error);
        });
    }else{
        const newUser = database.ref('user').push();
        newUser.set({
            name: name_user,
            email: email_user
        }).then(()=>{
            console.log('Usuário adicionado com sucesso!');
             alert('teste');
            
        }).catch((error)=>{
            console.error('Erro ao cadastrar o usuário', error);
        })
    }
});

database.ref('user').on('value',(dados)=>{
    list.innerHTML ='';
    dados.forEach((elemento) => {
        const userId = elemento.key;
        const user = elemento.val();

        const li = document.createElement('li');

        li.innerHTML= `
        <span>${user.name} - ${user.email}</span>
        <button class="btn-edit" onclick="editUser('${userId}' , '${user.name}',
        '${user.email}')">edit</button>
        <button class="btn-remove" onclick="deleteUser('${userId}')">delete</button>
        `;
        list.appendChild(li);
    });
});

window.editUser = (id, nameU, emailU) =>{
    name.value = nameU;
    email.value = emailU;
    id_user.value = id;
}

window.deleteUser = (id)=>{
    if(confirm('Você desejo mesmo deletar o usuário?')){

        database.ref('user/' + id).remove().then(()=>{
            console.log('Usuário exluido com sucesso!');
        }).catch((error)=>{
            console.error("Erro ao exluir usuário", error);
        });
    }
}