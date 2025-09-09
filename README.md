<h1 align="center">「 Flutter 」- Grene</h1>




<h2 id=objective>📌 Objetivos</h2>

O objetivo do projeto é criar um aplicativo em Flutter que conecta usuários a vasos inteligentes, permitindo acompanhar o estado de suas plantas em tempo real com base em sensores e valores ideais de cultivo.

## ⚙️ Funcionalidades

- Login de usuário com autenticação JWT.
- Cadastro e gerenciamento de plantas/vasos.
- Consulta de catálogo de plantas com valores ideais.
- Monitoramento em tempo real do estado da planta (temperatura, umidade, luminosidade e solo).
- Interface responsiva e intuitiva.

## 💻 Tecnologias

Ferramentas utilizadas no desenvolvimento do projeto:

- **Framework:** [Flutter](https://flutter.dev/)
- **Linguagem:** [Dart](https://dart.dev/)
- **Backend:** [Django REST Framework](https://www.djangoproject.com/)
- **Gerenciamento de estado:** Controllers simples (MVC-like)
- **Dependências principais:**
  - [http](https://pub.dev/packages/http) → requisições HTTP  
  - [shared_preferences](https://pub.dev/packages/shared_preferences) → armazenamento local de tokens  

## 📋 Instalação

1. Clone o repositório:
   ```bash
   git clone https://github.com/GabiScha/Grene
   ```

2. Acesse a pasta do projeto:
   ```bash
   cd grene
   ```

3. Instale as dependências:
   ```bash
   flutter pub get
   ```

4. Execute o backend (Django) na porta 8000:
   ```bash
   python manage.py runserver
   ```

5. Rode o aplicativo Flutter:
   ```bash
   flutter run
   ```

## 📂 Estrutura do Projeto

```plaintext
lib/
├── controllers/      # Controladores (AuthController, PlantaController)
├── models/           # Modelos (Planta)
├── services/         # Serviços de API (ApiService, PlantaService)
├── theme/            # Estilos globais (AppColors)
├── views/            # Telas principais (Login, Home, Plants, User, Config)
├── widgets/          # Widgets reutilizáveis (botões, campos, plantas animadas)
└── main.dart         # Arquivo principal
```

## 🏷️ Autores

- [GabiScha](https://www.linkedin.com/in/gabrielaschaper/)  
- [Pedro](https://www.linkedin.com/)


