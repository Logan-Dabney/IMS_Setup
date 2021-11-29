import 'dart:convert';
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
                  bool isSelected = false;
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
    List<int> message = [numOfChecked];
    for(int i = 0; i < selectedTreatments.length; i++){
      // Getting the number of muscle profiles in a specific treatment profile
      // add to the message
      int numOfMuscleProfiles = widget.treatmentProfiles[selectedTreatments[i]].muscleProfiles.length;
      message.add(numOfMuscleProfiles);
      // iterate through the muslce profiles and add information.
      for(int a = 0; a < numOfMuscleProfiles; a++){
        MuscleProfile muscle = widget.treatmentProfiles[selectedTreatments[i]].muscleProfiles[a];
        message.add(muscle.id!);            // muscle id
        message.add(0);                    // coarse freq
        message.add(muscle.pulse.round());         // fine freq
        message.add(muscle.intensity.round());     // amplitude freq
        message.add(muscle.timeDuration.round());  // time
      }
    }

    // Putting the number of bytes in the front.
    // Todo: add that it can't go above a byte long
    message.insert(0, message.length);

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

        // TODO: pop page from navigator
      } catch (e) {
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


// await BluetoothConnection.toAddress(widget.device.address).then((_connection) {
//   print('Connected to the device');
//   connection = _connection;
//   setState(() {
//     isConnecting = false;
//     isDisconnecting = false;
//   });
//
//   connection.input!.listen(_onDataReceived).onDone(() {
//     // There should be `isDisconnecting` flag to show are we are (locally)
//     // in middle of disconnecting process, should be set before calling
//     // `dispose`, `finish` or `close`, which all causes to disconnect.
//     // If we except the disconnection, `onDone` should be fired as result.
//     // If we didn't except this (no flag set), it means closing by remote.
//     if (isDisconnecting) {
//       print('Disconnecting locally!');
//     } else {
//       print('Disconnected remotely!');
//     }
//     if (this.mounted) {
//       setState(() {});
//     }
//   });
// }).catchError((error) {
//   print('Cannot connect, exception occured');
//   print(error);
// });