/// File: send_treatments.dart
/// Author: Logan Dabney (@Logan-Dabney)
/// Version: 0.1
/// Date: 2021-10-06
/// Copyright: Copyright (c) 2021

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:starter_project/Models/all_models.dart';

List<int> selectedTreatments = [];
int numOfChecked = 0;

class exportPage extends StatefulWidget {
  final BluetoothDevice device;
  List<TreatmentProfile> treatmentProfiles = [];

  exportPage({Key? key, required this.device, required this.treatmentProfiles}) : super(key: key);

  @override
  _exportPageState createState() => _exportPageState();
}

class _exportPageState extends State<exportPage> {
  late BluetoothConnection connection;
  bool isConnecting = true;

  bool isConnected = false;
  bool isDisconnecting = false;

  final TextEditingController textEditingController = new TextEditingController();

  Future<void> _initConnection() async{
    if(!isConnected){
      connection = await BluetoothConnection.toAddress(widget.device.address);

      isConnected = (connection != null && connection.isConnected);
    }
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
    }

    numOfChecked = 0;
    selectedTreatments = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initConnection(),
      builder: (context, future) {
        if (future.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              height: double.infinity,
              child: const Center(
                child: Icon(
                  Icons.bluetooth_disabled,
                  size: 200.0,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        } else if (future.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
                title: Text('Send Treatments'),
            ),
            body: ListView.builder(
                itemCount: widget.treatmentProfiles.length,
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
                                  widget.treatmentProfiles[i].name,
                                  style: TextStyle(fontSize: 20),
                                )
                            ),
                            Spacer(),
                            TreatmentCheckBox(index: i),
                          ]
                      ),
                      const Divider(
                        color: Colors.black26,
                        thickness: 1,
                      ),
                    ],
                  );
                }
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: ElevatedButton.icon(
              label:Text("Send"),
              icon: Icon(Icons.send_to_mobile, size: 30,),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
              onPressed: isConnected ? () => _sendMessage(createMessage()) : null,), // if connected send otherwise nothing
          );
        } else {
          return Text("T");
        }
      },
    );
  }

  List<int> createMessage(){
    List<int> message = [];
    if(numOfChecked != 0) {
      message.add(numOfChecked);
      for (int i = 0; i < selectedTreatments.length; i++) {
        // Getting the number of muscle profiles in a specific treatment profile
        // add to the message
        int numOfMuscleProfiles = widget.treatmentProfiles[selectedTreatments[i]].muscleProfiles.length;
        message.add(numOfMuscleProfiles);

        // iterate through the muscle profiles and add information.
        for (int a = 0; a < numOfMuscleProfiles; a++) {
          MuscleProfile muscle = widget.treatmentProfiles[selectedTreatments[i]].muscleProfiles[a];
          message.add(muscle.muscle.id);                  // muscle id
          message.add(0);                           // coarse freq
          message.add(muscle.pulse.round());        // fine freq
          message.add(muscle.intensity.round());    // amplitude freq
          message.add(muscle.timeDuration.round()); // time
        }
      }

      // Putting the number of bytes in the front.
      message.insert(0, message.length);
    }
    return message;
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }
  }

  void _sendMessage(List<int> message) async {
    textEditingController.clear();
    if (message.isNotEmpty) {
      try {
        connection.output.add(Uint8List.fromList(message)); // "\r\n terminator charactors"
        await connection.output.allSent;

        Navigator.popUntil(context, (route) => route.isFirst);
      } catch (e) {

        // TODO: Produce error messages
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

// Treatment Check Box for selection of treatments,
class TreatmentCheckBox extends StatefulWidget {
  int index;
  TreatmentCheckBox({Key? key, required this.index}) : super(key: key);

  @override
  _TreatmentCheckBoxState createState() => _TreatmentCheckBoxState();
}

class _TreatmentCheckBoxState extends State<TreatmentCheckBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isSelected,
      activeColor: Colors.deepPurple,
      onChanged: (value) {
        if (numOfChecked != 4) {
          setState(() {
            isSelected = value!;
            if(isSelected) {
              selectedTreatments.add(widget.index);
              numOfChecked++;
            }
            else {
              selectedTreatments.remove(widget.index);
              numOfChecked--;
            }
          });
        }
      },
    );
  }
}