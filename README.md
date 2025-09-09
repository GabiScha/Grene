<h1 align="center">「 Flutter 」- Grene </h1>

<h2 id=objective>📌 Objetivos</h2>

O objetivo do projeto é criar um aplicativo em Flutter que conecta usuários a vasos inteligentes, permitindo acompanhar o estado de suas plantas em tempo real com base em sensores e valores ideais de cultivo.

<h2 id=features>⚙️ Funcionalidades</h2>

- Login de usuário com autenticação JWT.
- Cadastro e gerenciamento de plantas/vasos.
- Consulta de catálogo de plantas com valores ideais.
- Monitoramento em tempo real do estado da planta (temperatura, umidade, luminosidade e solo).
- Interface responsiva e intuitiva.

<h2 id=technology>💻 Tecnologias</h2>

Ferramentas utilizadas no desenvolvimento do projeto:

- Framework: <a href="https://flutter.dev/">Flutter</a>
- Linguagem: <a href="https://dart.dev/">Dart</a>
- Backend: <a href="https://www.djangoproject.com/">Django REST Framework</a>
- Gerenciamento de estado: Controllers simples (MVC-like)
- Dependências principais:
  - <a href="https://pub.dev/packages/http">http</a> → requisições HTTP
  - <a href="https://pub.dev/packages/shared_preferences">shared_preferences</a> → armazenamento local de tokens

<h2 id=installation>📋 Instalação</h2>

1. Clone o repositório:
   git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git

2. Acesse a pasta do projeto:
   cd grene

3. Instale as dependências:
   flutter pub get

4. Execute o backend (Django) na porta 8000:
   python manage.py runserver

5. Rode o aplicativo Flutter:
   flutter run

<h2 id=structure>📂 Estrutura do Projeto</h2>
  lib/
  ├── controllers/      # Controladores (AuthController, PlantaController)
  ├── models/           # Modelos (Planta)
  ├── services/         # Serviços de API (ApiService, PlantaService)
  ├── theme/            # Estilos globais (AppColors)
  ├── views/            # Telas principais (Login, Home, Plants, User, Config)
  ├── widgets/          # Widgets reutilizáveis (botões, campos, plantas animadas)
  └── main.dart         # Arquivo principal

<h2 id=author>🏷️ Autores </h2>

. <a href="https://www.linkedin.com/in/gabrielaschaper/" target="_blank">GabiScha</a>
. <a href="https://www.linkedin.com/" target="_blank">Pedro</a>
