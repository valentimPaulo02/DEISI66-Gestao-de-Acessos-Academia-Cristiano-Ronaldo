# Guião de Instalação e Utilização

Aqui disponibilizamos um breve guião que possibilita a utilização da nossa aplicação.

O primeiro passo para ter acesso à aplicação é descarregar o repositório para o destino desejado, utilizando o comando,
```bash
git clone https://github.com/valentimPaulo02/DEISI66-Gestao-de-Acessos-Academia-Cristiano-Ronaldo.git
```

## Frontend
Para a instalação do frontend, é necessário ter o Flutter SDK instalado na máquina. Para tal, utilize este link:
- https://docs.flutter.dev/release/archive?tab=windows

Uma vez instalado, é necessário descarregar as dependências do projeto. Para tal utilizando o terminal do IDE, aceda à pasta do frontend através do comando,
```bash
cd fronted
```
Uma vez no frontend execute o seguinte comando de modo a descarregar as dependências,
```bash
flutter pub get
```

## Backend e Base de Dados

Uma vez que a aplicação tem o ambiente de Backend e a Base de Dados hóspedados em Docker, basta instalar o Docker Desktop utilizando o seguinte kink:
- https://docs.docker.com/desktop/install/windows-install/

Depois de instalado, basta aceder ao projeto e na pasta inicial do projeto onde se encontra o ficheiro 'compose.yaml' e utilizar o seguinte comando,
```bash
docker compose up
```

## Utilização

Depois de ter tudo instalado para executar a aplicação, basta aceder ao Docker Desktop e correr o multi-container. Após iniciado aceder ao projeto, aceder à pasta do fronted,
```bash
cd fronted
```

E de modo a executar o frontend, utilizar o comando,
```bash
flutter run
```

# Guião de Instalação e Utilização

A segurança e a monitorização de acessos são prioridades essenciais para todas as organizações. 
Visando aumentar a segurança e facilitar o controlo dos acessos, foi desenvolvido um projeto para a Academia Cristiano Ronaldo. 
Esta aplicação móvel permite fazer a gestão dos acessos à academia, bem como registar e controlar os atletas. 
Além disso, a aplicação oferece funcionalidades para fazer a gestão de pedidos de saída temporária ou de fim de semana feitos pelos atletas. 
Substituindo os métodos que anteriormente praticavam, o uso de uma aplicação proporciona uma gestão detalhada e mais segura das informações, garantindo um controle eficiente e preciso dos acessos e atividades dos atletas na academia.

![Logotipo Academia Cristiano Ronaldo](imagesR/drawerS.png)


