import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Conectivity extends StatefulWidget {
  const Conectivity({Key? key}) : super(key: key);

  @override
  State<Conectivity> createState() => _ConectivityState();
}

class _ConectivityState extends State<Conectivity> {

  String? subscription;
  late StreamSubscription _connectivitySubscription;


  @override
  initState() {
    super.initState();

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print('Current connectivity status: $result');
      setState(() {
        subscription =  result.name;
      });

    });

  }

// Be sure to cancel subscription after you are done
  @override
  dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Check conectivity'),
      ),
      body: Center(
        child: Text('Kết quả check : ${subscription == 'none' ? 'Not connected': subscription.toString()}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, ),),
      ),
    );
  }

}
