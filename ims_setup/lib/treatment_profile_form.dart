import 'package:flutter/material.dart';
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/Database/sqlite.dart';

TreatmentProfile treatmentProfile = TreatmentProfile("", [MuscleProfile(muscles[1],1,1,1)]);
final nameOfTreatment = TextEditingController();

// Creating the treatment profile page
class AddTreatmentProfileForm extends StatefulWidget {
  const AddTreatmentProfileForm({Key? key}) : super(key: key);

  @override
  _AddTreatmentProfileFormState createState() => _AddTreatmentProfileFormState();
}

class _AddTreatmentProfileFormState extends State<AddTreatmentProfileForm> {
  @override
  Widget build(BuildContext context){
    return ListView(
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      shrinkWrap: true,
        children: [
          TextField(
            controller: nameOfTreatment,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter Treatment Profile Name",
            ),
          ), // Treatment Name
          MuscleProfileForm(), // Form for muscle profiles
          SaveButton(),
        ]
    );
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
            )
          ],
        );
      },
    );
  }

  // Not set to return anything can be thought of a jump to this location
  _addMuscleProfile(int i){
    setState((){
      // add a blank muscle profile to treatmeantProfile
      treatmentProfile.muscleProfiles.insert(i++, MuscleProfile(muscles[1],1,1,1));
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

// Save Button
class SaveButton extends StatefulWidget {
  const SaveButton({Key? key}) : super(key: key);

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Save", style: TextStyle(fontSize: 25),),
      style: ElevatedButton.styleFrom(fixedSize: Size.fromHeight(70), ) ,
      onPressed: () => _pushedSave(),
    );
  }

  _pushedSave(){
    treatmentProfile.name = nameOfTreatment.text;
    SqliteDB.db.insertTreatmentProfile(treatmentProfile);
      //TODO: Save muscle profiles and treatment profile and reload home page
      //Save the treatmeant to treatment profiles
      // going to have to be a global variable
    // Can't be inside set state or it wont work.
    // Set state is specific for that widget
    // Navigator is a stack for the routes
    Navigator.of(context).pop();
  }
}





