import 'package:flutter/material.dart';
import '../componentes/app_bar_with_back.dart';
import '../componentes/inputfield.dart';
import '../main.dart';
import '../componentes/app_pages.dart';
import '../componentes/custom_app_bar.dart';
import '../componentes/navigation_manager.dart';

class Atleta {
  final String name;
  final String surname;
  final String under;

  Atleta({
    required this.name,
    required this.surname,
    required this.under,
  });
}

class ListaAtletasPage extends StatefulWidget {
  const ListaAtletasPage({Key? key}) : super(key: key);

  @override
  _ListaAtletasPageState createState() => _ListaAtletasPageState();
}

class _ListaAtletasPageState extends State<ListaAtletasPage> {
  int currentPage = 4;
  late NavigationManager navigationManager;
  List<Atleta> atletas = [];

  @override
  void initState() {
    super.initState();
    navigationManager = NavigationManager(context, currentPage);

    atletas = [
      Atleta(name: 'João', surname: 'Anacleto', under: 'under15'),
      Atleta(name: 'Valentim', surname: 'Paulo', under: 'under16'),
      Atleta(name: 'test', surname: 'aaa', under: 'under19')
    ];
  }

  void _navigateToPage(int index) {
    setState(() {
      currentPage = index;
    });

    navigationManager.navigateToPage(index);
  }

  void _editAtleta(Atleta atleta) {
    // fazer a parte de edição aqui
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditAtletaPage(atleta: atleta),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(191, 191, 191, 0.8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: CustomAppBar(
          currentPage: currentPage,
          onMenuItemSelected: _navigateToPage,
        ),
      ),
      drawer: AppPages(
        menuItems: menuItems,
        currentPageTitle: menuItems[currentPage - 1],
        currentPageIndex: currentPage,
        onMenuItemSelected: _navigateToPage,
        pageIcons: pageIcons,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Lista de Atletas',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register_user');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
                  ),
                  child: const Text('Adicionar Atleta'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: atletas.length,
              itemBuilder: (context, index) {
                final atleta = atletas[index];
                return ListTile(
                  title: Text(
                    '${atleta.name} ${atleta.surname} | ${atleta.under}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editAtleta(atleta);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EditAtletaPage extends StatefulWidget {
  final Atleta atleta;

  EditAtletaPage({required this.atleta});

  @override
  _EditAtletaPageState createState() => _EditAtletaPageState();
}

class _EditAtletaPageState extends State<EditAtletaPage> {
  String nameController = "";
  String surnameController = "";
  String underController = "";

  @override
  void initState() {
    super.initState();
    nameController = widget.atleta.name;
    surnameController = widget.atleta.surname;
    underController = widget.atleta.under;
  }

  void _updateAtleta() {
    //funcionalidade para dar update do atleta
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(191, 191, 191, 0.8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: CustomAppBarWithBack(
          onBackButtonPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Editar Atleta',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Name',
              onChanged: (value) {
                nameController = value;
              },
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Surname',
              onChanged: (value) {
                surnameController = value;
              },
            ),
            const SizedBox(height: 10),
            InputField(
              labelText: 'Class',
              onChanged: (value) {
                underController = value;
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _updateAtleta();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromRGBO(3, 110, 73, 1),
              ),
              child: const Text('Atualizar Atleta'),
            ),
          ],
        ),
      ),
    );
  }
}
