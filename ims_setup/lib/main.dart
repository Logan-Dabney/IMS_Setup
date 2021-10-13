import 'package:flutter/material.dart';
import 'treatment_profile_form.dart' as treatment_form;
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/Database/sqlite.dart';

List<TreatmentProfile> treatmentProfiles = [];

Future<void> main() async {
  runApp(const MyApp());
  treatmentProfiles = await SqliteDB.db.getTreatmentProfiles();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMS Setup',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const HomePage(),
    );
  }
}

// Widget (page) for profiles
// This will be the home page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profiles"),
          actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addTreatmentProfile),
          IconButton(icon: const Icon(Icons.import_export), onPressed: _exportProfiles)
          ],
        ),
      body: _addBody(),
    );
  }

  // Loads the add profile page
  void _addTreatmentProfile(){
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context){
            return Scaffold(
              appBar: AppBar(
                title: const Text("New Treatment Profile")
              ),
              body: const treatment_form.AddTreatmentProfileForm(),
            );
          }
      )
    );
  }

  // Loads the export profiles page
  void _exportProfiles(){

  }

  _editTreatmentProfile(){
//TODO: add database edit
  }

  _deleteTreatmentProfile(int i) async {
//TODO: add database delete
    SqliteDB.db.deleteTreatmentProfile(treatmentProfiles.removeAt(i));
  }

  _addBody(){
    // If there aren't any saved profiles show text to create on
    if (treatmentProfiles.isEmpty){
      _addTreatmentProfile;
    }

    // If there are saved treatments display them
    return
      ListView.builder(
        itemCount: treatmentProfiles.length,
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
        itemBuilder: (context, i){
          return Column(
            children: [
              Row(
                //TODO: Edit so it looks better
                children: [
                  Text(
                    treatmentProfiles[i].name,
                    style: TextStyle(fontSize: 20),
                  ),

                  IconButton(icon: const Icon(Icons.edit), onPressed: _editTreatmentProfile ),
                  IconButton(icon: const Icon(Icons.delete), onPressed: _deleteTreatmentProfile(i)),
                ]
              ),
              const Divider(
                color: Colors.purpleAccent,
                thickness: 3,
              ),
            ],
          );
        }
        );
  }
}

