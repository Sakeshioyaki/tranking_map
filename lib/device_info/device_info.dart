import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({Key? key}) : super(key: key);

  @override
  State<DeviceInfo> createState() => _DeviceInfoState();
}

class _DeviceInfoState extends State<DeviceInfo> {
  Map<String, dynamic>? data;
  String? device;

  Future<void> _incrementCounter() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.data}');
      setState(() {
        data = androidInfo.data;
        device = 'Android';
      });
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');
      print('uiewyfaiuyreu name :  ${iosInfo.name}');
      print('uiewyfaiuyreu name :  ${iosInfo.identifierForVendor}');
      print('uiewyfaiuyreu name :  ${iosInfo.isPhysicalDevice}');
      print('uiewyfaiuyreu name :  ${iosInfo.localizedModel}');
      print('uiewyfaiuyreu name :  ${iosInfo.model}');
      print('uiewyfaiuyreu name :  ${iosInfo.systemName}');
      print('uiewyfaiuyreu name :  ${iosInfo.systemVersion}');
      print('uiewyfaiuyreu name :  ${iosInfo.utsname.release}');
      iosInfo.data.forEach((key, value) {
        print('key $key     -----      $value}');
      });
      setState(() {
        data = iosInfo.data;
        device = 'IOS';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(device ?? 'Device info'),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 30,
        ),
        alignment: Alignment.center,
        child: data != null
            ? ListView.separated(
                itemCount: data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  String key = data!.keys.elementAt(index);
                  return rowInfo(
                    key,
                    data![key].toString(),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(thickness: 2);
                },
              )
            : const SizedBox(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildContain() {
    return data != null
        ? ListView.builder(
            itemCount: data?.length,
            itemBuilder: (BuildContext context, int index) {
              String key = data!.keys.elementAt(index);
              return rowInfo(
                key,
                data![key],
              );
            },
          )
        : const SizedBox();
  }

  Widget rowInfo(String key, String info) {
    return Row(
      children: [
        Text(
          '$key :',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 30),
        Flexible(
          child: Text(
            info,
            softWrap: true,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
