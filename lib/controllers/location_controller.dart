import 'package:get/get.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/models/vpn.dart';

import '../apis/apis.dart';

class LocationController extends GetxController{

List<Vpn> vpnList= Pref.vpnList;


final RxBool isLoading = false.obs;
Future<void> getVpnData() async{
  isLoading.value=true;
  vpnList.clear();
  vpnList =     await APIs.getVPNServers();
  isLoading.value = false;

}
}