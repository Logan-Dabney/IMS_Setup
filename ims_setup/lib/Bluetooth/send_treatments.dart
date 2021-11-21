import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:starter_project/Models/all_models.dart';

class exportPage extends StatefulWidget {
  final BluetoothDevice device;
  List<TreatmentProfile> treatmentProfiles = [];
  List<int> selectedTreatments = [];
  int numOfChecked = 0;

  exportPage({required this.device, required this.treatmentProfiles});

  @override
  _exportPageState createState() => _exportPageState();
}

class _exportPageState extends State<exportPage> {
  late BluetoothConnection connection;
  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;
  final TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.device.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                    Checkbox(
                      value: isSelected,
                      activeColor: Colors.deepPurple,
                      onChanged: (value) {
                        if (widget.numOfChecked != 4) {
                          setState(() {
                            isSelected = value!;
                            if(isSelected) {
                              widget.selectedTreatments.add(i);
                              widget.numOfChecked++;
                            }
                            else {
                              widget.selectedTreatments.remove(i);
                              widget.numOfChecked--;
                            }
                          });
                        }
                      },
                    ),
                    ElevatedButton(
                      child: Text("Send", style: TextStyle(fontSize: 25),),
                      style: ElevatedButton.styleFrom(fixedSize: Size.fromHeight(70),),
                      onPressed: isConnected && widget.numOfChecked != 0 ? () => _sendMessage(createMessage()) : null, // if connected send otherwise nothing
                    ),
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
  }

  String createMessage(){
    // TODO: Turn selected profiles into string
    String message = widget.numOfChecked.toString();
    for(int i = 0; i < widget.selectedTreatments.length; i++){
      // Getting the number of muscle profiles in a specific treatment profile
      // add to the message
      int numOfMuscleProfiles = widget.treatmentProfiles[widget.selectedTreatments[i]].muscleProfiles.length;
      message += numOfMuscleProfiles.toString();

      // iterate through the muslce profiles and add information.
      for(int a = 0; a < numOfMuscleProfiles; i++){
        MuscleProfile muscle = widget.treatmentProfiles[widget.selectedTreatments[i]].muscleProfiles[a];
        message += muscle.id.toString();            // muscle id
        message += 0.toString();                    // coarse freq
        message += muscle.pulse.toString();         // fine freq
        message += muscle.intensity.toString();     // amplitude freq
        message += muscle.timeDuration.toString();  // time
      }
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

  void _sendMessage(String message) async {
    message = message.trim();
    textEditingController.clear();

    if (message.isNotEmpty) {
      // Putting the number of bytes in the front.
      // var bytes = utf8.encode(message);
      // bytes.insert(0, bytes.length);
      
      try {
        connection.output.add(Uint8List.fromList(utf8.encode(message))); // "\r\n terminator charactors"
        await connection.output.allSent;

        // TODO: pop page from navigator
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}