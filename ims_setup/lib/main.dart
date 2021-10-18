import 'package:flutter/material.dart';
import 'treatment_profile_form.dart' as treatment_form;
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/Database/sqlite.dart';

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
          title: const Text("Treatments"),
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
    ).then((_) {
      // This block runs when you have returned back to refresh the page
      setState(() {
        setVariables();
      });
    });
  }

  // Loads the export profiles page
  void _exportProfiles(){

  }

  _addBody(){
    return FutureBuilder(
        future: setVariables(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            // If there aren't any saved profiles show text
            if (treatmentProfiles.isEmpty){
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "No Treatments",
                        style: TextStyle(fontSize: 50, color: Colors.black26),
                      )
                    ]
                  )
              );
            }

            // If there are saved treatments display them
            return ListView.builder(
                itemCount: treatmentProfiles.length,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, i){
                  return Column(
                    children: [
                      Row(
                        //TODO: Edit so it looks better
                          children: [
                            Padding (
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child:
                                Text(
                                  treatmentProfiles[i].name,
                                  style: TextStyle(fontSize: 20),
                                )
                            ),
                            Spacer(),
                            IconButton(icon: const Icon(Icons.edit), onPressed: _editTreatmentProfile(i)),
                            IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteTreatmentProfile(i)),
                          ]
                      ),
                      const Divider(
                        color: Colors.black26,
                        thickness: 1,
                      ),
                    ],
                  );
                }
                );
          } else{
            return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "No Treatments",
                        style: TextStyle(fontSize: 50, color: Colors.black26),
                      )
                    ]
                )
            );
          }
        },
    );
  }

  _editTreatmentProfile(int i){
    //TODO: add database edit and new page to edit data
    treatment_form.treatmentProfile = treatmentProfiles[i];
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

Future<String> setVariables() async{
  treatmentProfiles = await SqliteDB.db.getTreatmentProfiles();
  return Future.value("download successful"); // return your response
}

// If there aren't any saved profiles show text to create on
// if (treatmentProfiles.isEmpty){
//   return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Text(
//             "No Treatments",
//             style: TextStyle(fontSize: 50, color: Colors.black26),
//           )
//         ]
//       )
//   );
// }

// If there are saved treatments display them
// return
//   ListView.builder(
//       itemCount: treatmentProfiles.length,
//       physics: ClampingScrollPhysics(),
//       shrinkWrap: true,
//       itemBuilder: (context, i){
//         return Column(
//           children: [
//             Row(
//               //TODO: Edit so it looks better
//                 children: [
//                   Text(
//                     treatmentProfiles[i].name,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   IconButton(icon: const Icon(Icons.edit), onPressed: _editTreatmentProfile(i)),
//                   IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteTreatmentProfile(i)),
//                 ]
//             ),
//             const Divider(
//               color: Colors.purpleAccent,
//               thickness: 3,
//             ),
//           ],
//         );
//       }
//   );