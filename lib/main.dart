import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Personne.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo SQfLite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  /*début attribut de la classe*/
  Map<String, dynamic> mapPersonne = {};
  late Map<String, dynamic> mapPersonneRecuperee;
  Personne personneEnregistree = Personne();
  Personne personneRecuperee = Personne();
  late PersonneProvider provider;
  /*fin attribut de la classe*/

  @override
  void initState() {
    super.initState();
    getInstance();
  }

  void getInstance()  {
    provider = PersonneProvider.instance;
  }

  @override
  void dispose() {
    super.dispose();
    nomController.dispose();
    prenomController.dispose();
    ageController.dispose();
    idController.dispose();
    provider.close();
  }

  Future<void> enregistrer() async {
    if (nomController.text != '' && prenomController.text != '' && ageController.text != ''){
      try {
        mapPersonne = {
          'nom': nomController.text,
          'prenom': prenomController.text,
          'age': ageController.text
        };

        personneEnregistree = Personne.fromMap(mapPersonne);

        await provider.insert(personneEnregistree);

        // Utiliser Future.delayed pour éviter les problèmes de contexte asynchrone
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                title: Text('Enregistrement'),
                content: Text('Les données ont été enregistrées !'),
              );
            },
          );
        });
      } catch (error) {
        // Utiliser Future.delayed pour éviter les problèmes de contexte asynchrone
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Erreur d\'enregistrement'),
                content: Text('Une erreur est survenue lors de l\'enregistrement : $error'),
              );
            },
          );
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Erreur d\'enregistrement'),
            content: Text("Il manque des données"),
          );
        },
      );
    }
  }

  Future<void> recuperer() async {
    if (idController.text != ''){
      try {
        //............A COMPLETER............
        //récupérer une personne avec l'id entré et mettre cette personne dans la variable appropriée 

        Personne? personne = await provider.getPersonne(int.parse(idController.text));

        personneRecuperee = personne;

        setState(() {
          personneRecuperee;
        });
      } catch (error) {
        // Utiliser Future.delayed pour éviter les problèmes de contexte asynchrone
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Erreur de récupération'),
                content: Text('Une erreur est survenue lors de la récupération : $error'),
              );
            },
          );
        });
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('Récupération'),
            //content: Text............A COMPLETER............),
          );
        },
      );
    }
  }

  Future<void> supprimer() async {
    BuildContext localContext = context; // Stocker le contexte localement

    try {
      
      if (personneRecuperee.id == null) {
        throw Exception('Aucune personne sélectionnée pour la suppression.');
      }

      
      await provider.delete(personneRecuperee.id!);

      setState(() {
        personneRecuperee = Personne();
      });

      // Utiliser Future.delayed pour éviter les problèmes de contexte asynchrone
      Future.delayed(Duration.zero, () {
        showDialog(
          context: localContext, // Utiliser le contexte local
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text('Suppression'),
              //content: Text(............A COMPLETER............),
              content: Text('Les données ont été supprimées !')
            );
          },
        );
      });
    } catch (error) {
      // Utiliser Future.delayed pour éviter les problèmes de contexte asynchrone
      Future.delayed(Duration.zero, () {
        showDialog(
          context: localContext, // Utiliser le contexte local
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erreur de suppression'),
              //content: Text(............A COMPLETER............),
              content: Text('Une erreur est survenue lors de la suppression : $error'),
            );
          },
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Icon(
              Icons.account_circle,
              size: 80.0,
              color: Colors.blue,
            ),
            const Text('Données soumises :'),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Nom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 200, // Adjust this width as needed
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nom',
                          ),
                          controller: nomController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Prénom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 200, // Adjust this width as needed
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Prénom',
                          ),
                          controller: prenomController,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Age : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 200, // Adjust this width as needed
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                          ),
                          controller: ageController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Text('Données récupérées :'),
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'id : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 200, // Adjust this width as needed
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'identifiant',
                          ),
                          controller: idController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Nom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()['nom'] != null
                          ? Text(
                        '${personneRecuperee.toMap()['nom']}',
                        style: const TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : const Text(
                        'Aucune donnée',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Prénom : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()['prenom'] != null
                          ? Text(
                        '${personneRecuperee.toMap()['prenom']}',
                        style: const TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : const Text(
                        'Aucune donnée',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Age : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      personneRecuperee.toMap()['age'] != null
                          ? Text(
                        '${personneRecuperee.toMap()['age']}',
                        style: const TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : const Text(
                        'Aucune donnée',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: enregistrer,
                  child: const Text('Enregistrer'),
                ),
                ElevatedButton(
                  onPressed: recuperer,
                  child: const Text('Lire les données'),
                ),
                ElevatedButton(
                  onPressed: supprimer,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}