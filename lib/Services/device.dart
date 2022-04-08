import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:graduation_project/widgets/Constants.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final Function onTap;
  final BluetoothDevice device;

  BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(Icons.devices),
      title: Text(device.name ?? "Unknown device"),
      subtitle: Text(device.address.toString()),
      tileColor: Colors.white,
      trailing: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7)),
            color: buttonsColor,
        ),
        child: TextButton(
          child: Text('Connect',
          style: TextStyle(
              color: Colors.white,
          ),),
          onPressed: onTap,
        ),
      ),
    );
  }
}