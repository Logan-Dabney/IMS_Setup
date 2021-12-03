import 'package:flutter/material.dart';
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/Database/sqlite.dart';

late TreatmentProfile treatmentProfile =
    TreatmentProfile("", [MuscleProfile(muscles[0], 1, 1, 1)]);
final nameOfTreatment = TextEditingController();

//TODO: clear when just going back and not saving
//For multiple buttons with same route
class TreatmentProfileFormRoute extends StatelessWidget {
  final String name;
  final bool isEdit;

  TreatmentProfileFormRoute({required this.name, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return TreatmentProfileForm(isEdit: isEdit, name: name);
  }
}

// Creating the treatment profile page
class TreatmentProfileForm extends StatefulWidget {
  final String name;
  bool isEdit;

  TreatmentProfileForm({Key? key, required this.isEdit, required this.name})
      : super(key: key);

  @override
  _TreatmentProfileFormState createState() => _TreatmentProfileFormState();
}

class _TreatmentProfileFormState extends State<TreatmentProfileForm> {
  bool _validate = false;

  @override
  void dispose() {
    // clear user input
    treatmentProfile =
        TreatmentProfile("", [MuscleProfile(muscles[0], 1, 1, 1)]);
    nameOfTreatment.text = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: set the treatment profile if one was passed to be edited
    return Scaffold(
      appBar: AppBar(
        title: (widget.isEdit)
            ? Text("Edit Treatment Profile")
            : Text("New Treatment Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: Column(
          children: [
            TextField(
              controller: nameOfTreatment,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "Enter Treatment Profile Name",
                errorText: _validate ? 'Can\'t be empty' : null,
              ),
            ),
            const MuscleProfileForm(), // Form for muscle profiles
            ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.save,
                    size: 30,
                  ),
                  Text(
                    "Save",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromHeight(50),
              ),
              onPressed: () => _pushedSave(),
            )
          ],
        ),
      ),
    );
  }

  _pushedSave() {
    if (nameOfTreatment.text != "") {
      treatmentProfile.name = nameOfTreatment.text;

      // How it is saved to db depending on editing
      if (widget.isEdit) {
        SqliteDB.db.updateTreatmentProfile(treatmentProfile);
      } else {
        SqliteDB.db.insertTreatmentProfile(treatmentProfile);
      }

      //return home
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
  final _paddingLabel = const EdgeInsets.only(left: 15, top: 10);
  final _paddingInput = const EdgeInsets.only(top: 10);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: treatmentProfile.muscleProfiles.length,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        return Card(
            color: (i.isEven) ? Colors.deepPurple : Colors.black45,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: _paddingLabel,
                        child: Text(
                          "Muscle:",
                          style: _biggerFont,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, right: 25, left: 15),
                        child: MuscleDropDown(index: i,),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                        child: Container(
                          // Padding Node that contains an item (Widget)
                          padding: _paddingLabel,
                          child: Text(
                            // Text Widget
                            "Intensity:",
                            style: _biggerFont,
                          ),
                        ),
                    ),
                    Expanded(
                      flex: 7,
                        child: Container(
                          padding: _paddingInput,
                          child: IntensitySlider(
                            index: i,
                          ),
                        ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(flex: 3,
                        child: Container(
                          padding: _paddingLabel,
                          child: Text(
                            "Pulse:",
                            style: _biggerFont,
                          ),
                        ),),
                    Expanded(flex: 7,
                        child: Container(
                          padding: _paddingInput,
                          child: PulseSlider(
                            index: i,
                          ),
                        ),),
                  ],),
                Row(
                  children: [
                    Expanded(flex: 3,
                        child: Container(
                          padding: _paddingLabel,
                          child: Text(
                            "Time:",
                            style: _biggerFont,
                          ),
                        ),),
                    Expanded(flex: 7,
                        child: Container(
                          padding: _paddingInput,
                          child: TimeSlider(
                            index: i,
                          ),
                        ),),
                  ],),
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
              ],
            ));
      },
    );
  }

  // Not set to return anything can be thought of a jump to this location
  _addMuscleProfile(int i) {
    setState(() {
      // add a blank muscle profile to treatmeantProfile
      if (i == 0 || (i + 1) == treatmentProfile.muscleProfiles.length) {
        treatmentProfile.muscleProfiles.add(MuscleProfile(muscles[0], 1, 1, 1));
      } else {
        treatmentProfile.muscleProfiles.insert(i + 1, MuscleProfile(muscles[0], 1, 1, 1));
      }
    });
  }

  // Not set to return anything can be thought of a jump to this location
  _removeMuscleProfile(int i) {
    setState(() {
      // TODO: maintain a list of the muscle profiles to delete
      if (treatmentProfile.muscleProfiles.length > 1) {
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
    return Slider(
      // Returns a Slider widget
      value: treatmentProfile.muscleProfiles[widget.index].intensity,
      min: 1,
      max: 30,
      divisions: 30,
      inactiveColor: (widget.index.isEven) ? Colors.black45 : Colors.white,
      activeColor:
          (widget.index.isEven) ? Colors.white : Colors.deepPurpleAccent,
      label:
          'Intensity: ${treatmentProfile.muscleProfiles[widget.index].intensity.round().toString()} V',
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
      inactiveColor: (widget.index.isEven) ? Colors.black45 : Colors.white,
      activeColor:
          (widget.index.isEven) ? Colors.white : Colors.deepPurpleAccent,
      label:
          'Pulse: ${treatmentProfile.muscleProfiles[widget.index].pulse.round().toString()} Hz',
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
      inactiveColor: (widget.index.isEven) ? Colors.black45 : Colors.white,
      activeColor:
          (widget.index.isEven) ? Colors.white : Colors.deepPurpleAccent,
      label:
          'Time: ${treatmentProfile.muscleProfiles[widget.index].timeDuration.round().toString()} min',
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
        color: (widget.index.isEven) ? Colors.black45 : Colors.deepPurpleAccent,
      ),
      onChanged: (int? value) {
        setState(() {
          // have to reset the muscle profile using it's value -1 for the index value
          treatmentProfile.muscleProfiles[widget.index].muscle =
              muscles[value! - 1];
        });
      },
      items: muscles.map((Muscle muscle) {
        //map the muscle list to a dropdown menu item list
        return DropdownMenuItem(
            value: muscle.id,         // set the value to the id
            child: Text(muscle.name)  // set the text to the name
            );
      }).toList(), // turn it to a list
    );
  }
}

// reset the variables for the page
reset() {
  treatmentProfile = TreatmentProfile("", [MuscleProfile(muscles[0], 1, 1, 1)]);
  nameOfTreatment.text = "";
}

// set the variables for the page
set(var currentTreatmentProfile) {
  if (currentTreatmentProfile == null) {
    treatmentProfile =
        TreatmentProfile("", [MuscleProfile(muscles[0], 1, 1, 1)]);
  } else {
    treatmentProfile = currentTreatmentProfile;
    nameOfTreatment.text = treatmentProfile.name;
  }
}
