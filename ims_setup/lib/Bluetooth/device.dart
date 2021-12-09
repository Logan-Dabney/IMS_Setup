/// File: device.dart
/// Author: Logan Dabney (@Logan-Dabney)
/// Version: 0.1
/// Date: 2021-10-06
/// Copyright: Copyright (c) 2021

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({required this.onTap, required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap,
      leading: Icon(Icons.devices),
      title: Text(device.name ?? "Unknown device"),
      subtitle: Text(device.address.toString()),
      trailing: FlatButton(
        child: Text('Connect'),
        onPressed: () => onTap(),
        color: Colors.deepPurple,
      ),
    );
  }
}