import 'package:flutter/material.dart';
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/Database/sqlite.dart';

late TreatmentProfile treatmentProfile = TreatmentProfile("", [MuscleProfile(muscles[0], 1, 1, 1)]);
final nameOfTreatment = TextEditingController();

//TODO: clear when just going back and not saving
//For multiple buttons with same route
class TreatmentProfileFormRoute extends StatelessWidget{
  final String name;
  bool isEdit;

  TreatmentProfileFormRoute({required this.name, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: (isEdit) ? Text("Edit Treatment Profile") : Text("New Treatment Profile")
        ),
        body: Hero(
          tag: name,
          child: TreatmentProfileForm(isEdit: isEdit),
        )
    );
  }
}

// Creating the treatment profile page
class TreatmentProfileForm extends StatefulWidget {
  bool isEdit;
  TreatmentProfileForm({Key? key, required this.isEdit}) : super(key: key);

  @override
  _TreatmentProfileFormState createState() => _TreatmentProfileFormState();
}

class _TreatmentProfileFormState extends State<TreatmentProfileForm> {
  bool _validate = false;

  @override
  Widget build(BuildContext context){
    // TODO: set the treatment profile if one was passed to be edited
    return ListView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      shrinkWrap: true,
        children: [
          TextField(
            controller: nameOfTreatment,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Treatment Profile Name",
              errorText: _validate ? 'Can\'t be empty' : null,
            ),
          ),
          MuscleProfileForm(), // Form for muscle profiles
          ElevatedButton(
            child: Text("Save", style: TextStyle(fontSize: 25),),
            style: ElevatedButton.styleFrom(fixedSize: Size.fromHeight(70),),
            onPressed: () => _pushedSave(),
          ),
        ]
    );
  }
  //Save the treatmeant to treatment profiles
  // going to have to be a global variable
  // Can't be inside set state or it wont work.
  // Set state is specific for that widget
  // Navigator is a stack for the routes
  _pushedSave(){
    if(nameOfTreatment.text != "") {
      treatmentProfile.name = nameOfTreatment.text;
      // TODO: work on if they delete a mucle profile
      if(widget.isEdit){
        SqliteDB.db.updateTreatmentProfile(treatmentProfile);
      } else {
        SqliteDB.db.insertTreatmentProfile(treatmentProfile);
      }
      reset();
      Navigator.of(context).pop();
    } else {
      // display error message
      setState(() {
        _validate = true;
      });
    }
  }
}

// Muscle profile added to treatment
class MuscleProfileForm extends StatefulWidget {
  const MuscleProfileForm({Key? key}) : super(key: key);

  @override
  _MuscleProfileFormState createState() => _MuscleProfileFormState();
}

class _MuscleProfileFormState extends State<MuscleProfileForm> {
  // might have to change this to a list of muscleProfiles
  // Create an empty treatmentprofile with nothing in it besides a blank
  // muscle profile, The list of muscle profiles is the amount of
  // items built for the list view
  // global.TreatmentProfile treatmentProfile = global.TreatmentProfile("",
  //     [global.MuscleProfile(global.muscles[1],0,0,0)]);
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context){
    return ListView.builder(
      itemCount: treatmentProfile.muscleProfiles.length,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Muscle",
                textAlign: TextAlign.center,
                style: _biggerFont,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: MuscleDropDown(index: i,),
            ),
            Container( // Padding Node that contains an item (Widget)
              padding: EdgeInsets.only(top: 15),
              child: Text( // Text Widget
                "Intensity",
                textAlign: TextAlign.center,
                style: _biggerFont,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: IntensitySlider(index: i,),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Pulse",
                textAlign: TextAlign.center,
                style: _biggerFont,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: PulseSlider(index: i,),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Text(
                "Time Duration",
                textAlign: TextAlign.center,
                style: _biggerFont,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TimeSlider(index: i,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30,
                  onPressed: () => _addMuscleProfile(i),
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  iconSize: 30,
                  onPressed: () => _removeMuscleProfile(i),
                ),
              ],
            ),
            const Divider(
              color: Colors.black26,
              thickness: 2,
            ),
          ],
        );
      },
    );
  }

  // Not set to return anything can be thought of a jump to this location
  _addMuscleProfile(int i){
    setState((){
      // add a blank muscle profile to treatmeantProfile
      if(i == 0 || (i+1) == treatmentProfile.muscleProfiles.length) {
        treatmentProfile.muscleProfiles.add(MuscleProfile(muscles[0],1,1,1));
      } else {
        treatmentProfile.muscleProfiles.insert(i+1, MuscleProfile(muscles[0],1,1,1));
      }
    });
  }

  // Not set to return anything can be thought of a jump to this location
  _removeMuscleProfile(int i){
    setState((){
      // TODO: maintain a list of the muscle profiles to delete
      if(treatmentProfile.muscleProfiles.length > 1){
        treatmentProfile.muscleProfiles.removeAt(i);
      }
    });
  }
}

// Slider for intensity (V) of muscle profile
class IntensitySlider extends StatefulWidget {
  int index;
  IntensitySlider({Key? key, required this.index}) : super(key: key);

  @override
  _IntensitySliderState createState() => _IntensitySliderState();
}

class _IntensitySliderState extends State<IntensitySlider> {

  @override
  Widget build(BuildContext context) {
    return Slider(  // Returns a Slider widget
      value: treatmentProfile.muscleProfiles[widget.index].intensity,
      min: 1,
      max: 30,
      divisions: 30,
      activeColor: Colors.deepPurpleAccent,
      label: 'Intensity: ${treatmentProfile.muscleProfiles[widget.index].intensity.round().toString()} V',
      onChanged: (double value) {
        setState(() {
          treatmentProfile.muscleProfiles[widget.index].intensity = value;
        });
      },
    );
  }
}

// Pulse slider (Hz) of muscle profile
class PulseSlider extends StatefulWidget {
  int index;
  PulseSlider({Key? key, required this.index}) : super(key: key);

  @override
  _PulseSliderState createState() => _PulseSliderState();
}

class _PulseSliderState extends State<PulseSlider> {

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: treatmentProfile.muscleProfiles[widget.index].pulse,
      min: 1,
      max: 100,
      divisions: 100,
      activeColor: Colors.deepPurpleAccent,
      label: 'Pulse: ${treatmentProfile.muscleProfiles[widget.index].pulse.round().toString()} Hz',
      onChanged: (double value) {
        setState(() {
          treatmentProfile.muscleProfiles[widget.index].pulse = value;
        });
      },
    );
  }
}

// Time duration (min) of muscle profile
class TimeSlider extends StatefulWidget {
  int index;
  TimeSlider({Key? key, required this.index}) : super(key: key);

  @override
  _TimeSliderState createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: treatmentProfile.muscleProfiles[widget.index].timeDuration,
      min: 1,
      max: 20,
      divisions: 20,
      activeColor: Colors.deepPurpleAccent,
      label: 'Time: ${treatmentProfile.muscleProfiles[widget.index].timeDuration.round().toString()} min',
      onChanged: (double value) {
        setState(() {
          treatmentProfile.muscleProfiles[widget.index].timeDuration = value;
        });
      },
    );
  }
}

// Muscle selection
class MuscleDropDown extends StatefulWidget {
  int index;
  MuscleDropDown({Key? key, required this.index}) : super(key: key);

  @override
  _MuscleDropDownState createState() => _MuscleDropDownState();
}

class _MuscleDropDownState extends State<MuscleDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: treatmentProfile.muscleProfiles[widget.index].muscle.id,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      isExpanded: true,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (int? value) {
        setState(() {
          // have to reset the muscle profile using it's value -1 for the index value
          treatmentProfile.muscleProfiles[widget.index].muscle = muscles[value! - 1];
        });
      },
      items: muscles.map((Muscle muscle) { //map the muscle list to a dropdown menu item list
        return DropdownMenuItem(
          value: muscle.id, // set the value to the id
          child: Text(muscle.name) // set the text to the name
        );
      }).toList(),  // turn it to a list
    );
  }
}

// reset the variables for the page
reset() {
  treatmentProfile = TreatmentProfile("", [MuscleProfile(muscles[0],1,1,1)]);
  nameOfTreatment.text = "";
}

// set the variables for the page
set(var currentTreatmentProfile){
  if(currentTreatmentProfile == null) {
    treatmentProfile =
        TreatmentProfile("", [MuscleProfile(muscles[0], 1, 1, 1)]);
  } else {
    treatmentProfile = currentTreatmentProfile;
    nameOfTreatment.text = treatmentProfile.name;
  }
}