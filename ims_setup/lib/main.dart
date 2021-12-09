/// File: main.dart
/// Author: Logan Dabney (@Logan-Dabney)
/// Version: 0.1
/// Date: 2021-10-06
/// Copyright: Copyright (c) 2021

import 'package:flutter/material.dart';
import 'treatment_profile_form.dart' as treatment_form;
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/Database/sqlite.dart';
import 'package:starter_project/Bluetooth/bluetooth_form.dart' as bluetooth;

List<TreatmentProfile> treatmentProfiles = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // set up the variables
    return MaterialApp(
      title: 'IMS Setup',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
      ),
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
          title: const Text(
            "Treatments",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontStyle: FontStyle.italic,
                fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: _addBody(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                heroTag: "export",
                child: const Icon(Icons.import_export, size: 35),
                onPressed: _exportProfiles,
                backgroundColor: Colors.white70,
                foregroundColor: Colors.deepPurple,
              ),
              FloatingActionButton(
                heroTag: "addTreatment",
                child: const Icon(
                  Icons.add,
                  size: 35,
                ),
                onPressed: _addTreatmentProfile,
                backgroundColor: Colors.white70,
                foregroundColor: Colors.deepPurple,
              ),
            ],
          ),
        ));
  }

  _addBody() {
    return FutureBuilder(
      future: setVariables(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If there aren't any saved profiles show text
          if (treatmentProfiles.isEmpty) {
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                  Text(
                    "No Treatments",
                    style: TextStyle(fontSize: 50, color: Colors.black26),
                  )
                ]));
          }

          // If there are saved treatments display them
          return ListView.builder(
              itemCount: treatmentProfiles.length,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                // create the muscle order for card
                var muscleText = "Muscle Order: ";
                for (var muscle in treatmentProfiles[i].muscleProfiles) {
                  muscleText += muscle.muscle.name + ", ";
                }

                return Card(
                  color: Colors.deepPurple,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 8,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: Text(
                                  treatmentProfiles[i].name,
                                  style: TextStyle(fontSize: 22),
                                )),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                                child: Text(
                                  muscleText,
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70),
                                )),
                          ])),
                      Spacer(),
                      Row(
                        children: [
                          Hero(
                            tag: i,
                            child: IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _editTreatmentProfile(i)),
                          ),
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTreatmentProfile(i)),
                        ],
                      )
                    ],
                  ),
                );
              });
        } else {
          return const Text(""); // show nothing while the builder is loading
        }
      },
    );
  }

  // Loads the add profile page
  void _addTreatmentProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => treatment_form.TreatmentProfileFormRoute(
                name: "New", isEdit: false)))
        .then((_) {
      // This block runs when you have returned back to refresh the page
      setState(() {
        setVariables();
      });
    });
  }

  // Loads the export profiles page
  void _exportProfiles() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => bluetooth.BluetoothFormRoute(
                  name: "Bluetooth Select",
                  treatmentProfiles: treatmentProfiles,
                )))
        .then((_) {
      // This block runs when you have returned back to refresh the page
      setState(() {
        setVariables();
      });
    });
  }

  _editTreatmentProfile(int i) {
    //TODO: add database edit and new page to edit data
    treatment_form.set(treatmentProfiles[i]);
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => treatment_form.TreatmentProfileFormRoute(
                name: "$i", isEdit: true)))
        .then((_) {
      // This block runs when you have returned back to refresh the page
      setState(() {
        setVariables();
      });
    });
  }

  _deleteTreatmentProfile(int i) {
//TODO: add database delete
    SqliteDB.db.deleteTreatmentProfile(treatmentProfiles[i]);
    treatmentProfiles.removeAt(i);
    setState(() {
      setVariables();
    });
  }
}

Future<String> setVariables() async {
  treatmentProfiles = await SqliteDB.db.getTreatmentProfiles();
  return Future.value("download successful"); // return your response
}
