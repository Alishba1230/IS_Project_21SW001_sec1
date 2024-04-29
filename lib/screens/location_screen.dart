import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn_basic_project/controllers/location_controller.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
   LocationScreen({super.key});

  @override
final _controller = LocationController();
  Widget build(BuildContext context) {
    if(_controller.vpnList.isEmpty)  _controller.getVpnData();

    return Obx(() => Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.blue,
          title: Text('VPN Locations(${_controller.vpnList.length})',
          style: TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold),),
          
                elevation: 10 ,
                flexibleSpace: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.4), // Shadow color with opacity
                    spreadRadius: 1, // Spread radius
                    blurRadius: 3, // Blur radius
                    offset: Offset(0, 6), // Offset from the app bar
                  ),
                ],
              ),
            ),
          ),
floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 10, right: 10),
  child: FloatingActionButton(onPressed: () {       
     _controller.getVpnData();
}, 
child: Icon(Icons.refresh_rounded),),
),
          body:  _controller.isLoading.value?
          _loadingWidget(): _controller.vpnList.isEmpty?_noVPNFound():_vpnData(),
      ),
    );
  }

  _vpnData() => ListView.builder(
    itemCount: _controller.vpnList.length, 
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.only(top: mq.height*.015, bottom: mq.height*.1, left: mq.width*.04, right: mq.width*.04),
    itemBuilder: (ctx, i) => VpnCard(vpn: _controller.vpnList[i],),);

  _loadingWidget() => SizedBox(
    width: double.infinity,height: double.infinity,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      LottieBuilder.asset('assets/lottie/loading.json', width: mq.width * .7,),
      Text('Loading VPNs....', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),)
      ],
  ),
  );

  _noVPNFound() => 
        Center(child: Text('Loading VPNs....', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),));
}