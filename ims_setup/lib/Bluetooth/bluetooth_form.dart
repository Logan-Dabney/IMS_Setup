import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:starter_project/Models/all_models.dart';
import 'package:starter_project/main.dart';
import 'connection.dart';
import 'send_treatments.dart';

//For multiple buttons with same route
class BluetoothFormRoute extends StatelessWidget{
  final String name;
  List<TreatmentProfile> treatmentProfiles = [];

  BluetoothFormRoute({required this.name, required this.treatmentProfiles});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FlutterBluetoothSerial.instance.requestEnable(),
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
          return Bluetooth_Select(treatmentProfiles);
        } else {
          return Bluetooth_Select(treatmentProfiles);
        }
      },
    );
  }
}

class Bluetooth_Select extends StatelessWidget {
  List<TreatmentProfile> treatmentProfiles = [];

  Bluetooth_Select(this.treatmentProfiles);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Connection'),
          ),
          body: SelectBondedDevicePage(
            onCahtPage: (device1) {
              BluetoothDevice device = device1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return exportPage(device: device, treatmentProfiles: treatmentProfiles,);
                  },
                ),
              );
            },
          ),
        ));
  }
}