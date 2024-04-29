import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/models/vpn.dart';
import 'package:vpn_basic_project/models/vpn_config.dart';
import 'package:vpn_basic_project/services/vpn_engine.dart';


class HomeController extends GetxController{

  final Rx<Vpn> vpn = Pref.vpn.obs; 

  final vpnState = VpnEngine.vpnDisconnected.obs;

void connectToVpn() {
    ///Stop right here if user not select a vpn
    if (vpn.value.openVPNConfigDataBase64.isEmpty) return;

    if (vpnState.value == VpnEngine.vpnDisconnected) {
      final data = Base64Decoder().convert(vpn.value.openVPNConfigDataBase64);
      final config = Utf8Decoder().convert(data);
      final  vpnConfig = VpnConfig(country: vpn.value.countryLong, username: 'vpn', password: 'vpn', config: config);
      ///Start if stage is disconnected
      VpnEngine.startVpn(vpnConfig);
      // startTimer.value = true;

    } else {
      ///Stop if stage is "not" disconnected
      ///            
    // startTimer.value = false;

      VpnEngine.stopVpn();
    }
  }
Color get getButtonColor{
  switch(vpnState.value){
    case VpnEngine.vpnDisconnected:
    return Colors.blue;
    case VpnEngine.vpnConnected:
    return Colors.green;
    default:
    return Colors.orange;
  }
}
String get getButtonText{
  switch(vpnState.value){
    case VpnEngine.vpnDisconnected:
    return 'Tap to Connect';
    case VpnEngine.vpnConnected:
    return 'Disconnect';
    default:
    return 'Connecting...';
  }
}
}