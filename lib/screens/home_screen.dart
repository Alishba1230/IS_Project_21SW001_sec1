

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:vpn_basic_project/controllers/home_controller.dart';
import 'package:vpn_basic_project/helpers/pref.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/screens/location_screen.dart';
import 'package:vpn_basic_project/widgets/count_down_timer.dart';
import 'package:vpn_basic_project/widgets/home_card.dart';

import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';

class HomeScreen extends StatelessWidget {
     HomeScreen({super.key});

  final _controller = Get.put(HomeController());

//   @override
  @override
  Widget build(BuildContext context) {
    //Add listener to update vpn state
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });
    return Scaffold(

      appBar: AppBar(
        
        backgroundColor: Colors.blue,
        leading: Icon(Icons.home, color: Colors.white, size: 28,),
        title: Text('VPN 21SW001',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: (){Get.changeThemeMode(Pref.isDarkMode?ThemeMode.light:ThemeMode.dark);Pref.isDarkMode=!Pref.isDarkMode;}, 
            icon: Icon(
              Icons.brightness_medium,
              size: 26, color: Colors.white, )),
           IconButton(
            padding: EdgeInsets.only(right: 8),
            onPressed: (){}, 
            icon: Icon(
              Icons.info,
              size: 26, color: Colors.white, )),
              ],
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
        bottomNavigationBar: _changeLocation(context),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,        
          children: [
            
            Obx(()=> _vpnButton()),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty? 'Country': _controller.vpn.value!.countryLong, 
                  subtitle: 'FREE', 
                  icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blueAccent,
                  child: _controller.vpn.value.countryLong.isEmpty? Icon(Icons.vpn_lock_rounded, size: 30, color: Colors.white,) 
                  : null,
                  backgroundImage: _controller.vpn.value.countryLong.isEmpty?null:
                  AssetImage('assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png'),
                  )),
                  HomeCard(
                  title: _controller.vpn.value.countryLong.isEmpty? 'Country': _controller.vpn.value.ping+' ms', 
                  subtitle: 'PING', 
                  icon: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.equalizer_rounded, size: 30, color: Colors.white,)
                  )),
              ],),
            ),
            
            StreamBuilder<VpnStatus?>(
              initialData: VpnStatus(),
              stream: VpnEngine.vpnStatusSnapshot(),
              builder: (context, snapshot) => 
                    Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              HomeCard(
                title: '${snapshot.data?.byteIn ?? '0 kbps'}', 
                subtitle: 'DOWNLOAD', 
                icon: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.lightGreen,
                child: Icon(Icons.arrow_downward_rounded, size: 30, color: Colors.white,)
                )),
                HomeCard(
                title: '${snapshot.data?.byteOut ?? '0 kbps'}', 
                subtitle: 'UPLOAD', 
                icon: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.lightBlue,
                child: Icon(Icons.arrow_upward_rounded, size: 30, color: Colors.white,)
                )),
            ],)
              
            )
            
      
            
          ]
          ),
    );
  }

  

  //vpn button
  Widget _vpnButton() =>Column(
    children: [
      Semantics(
        button: true,
        child: InkWell(
          onTap: () {
            _controller.connectToVpn();
          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: _controller.getButtonColor.withOpacity(.1)),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle, color: _controller.getButtonColor.withOpacity(.3)),
            
              child: Container(
                width: mq.height * .14,
                height: mq.height * .14,
                decoration: BoxDecoration(shape: BoxShape.circle, color: _controller.getButtonColor),
                child: 
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new, 
                      size: 28, 
                      color: Colors.white,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _controller.getButtonText,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        
                      )
                      ],
                ),
                ),
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
        child: Text(
          _controller.vpnState.value == VpnEngine.vpnDisconnected ?
        'Not Connected'
        : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white,
                        ),
      ),
      ),
                  Obx(()=> CountDownTimer(startTimer: _controller.vpnState.value==VpnEngine.vpnConnected)),

    ],
  );

  Widget _changeLocation(BuildContext context) => 
  SafeArea(
    child: Semantics(
      button: true,
      child: InkWell(
        onTap: () => Get.to(() => LocationScreen()),
        child: Container(
          
          color: Theme.of(context).bottomNav,
          padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
          height: 60,
          child: Row(
            children: [
              Icon(Icons.explore_rounded, color: Colors.white, size: 38, ),
              SizedBox(width: 10,),
              Text('Change Location',
              style: TextStyle(color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500),),
              Spacer(),
              CircleAvatar(
                radius: 17,
                backgroundColor: Colors.white,
                child: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.blue, size: 30,),)
                
        
            ],
          )),
      ),
    ),
      
  );
}

// Center(
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   shape: StadiumBorder(),
//                   backgroundColor: Theme.of(context).primaryColor,
//                 ),
//                 child: Text(
//                   _controller.vpnState.value == VpnEngine.vpnDisconnected
//                       ? 'Connect VPN'
//                       : _controller.vpnState.value.replaceAll("_", " ").toUpperCase(),
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: _connectClick,
//               ),
//             ),
//             StreamBuilder<VpnStatus?>(
//               initialData: VpnStatus(),
//               stream: VpnEngine.vpnStatusSnapshot(),
//               builder: (context, snapshot) => Text(
//                   "${snapshot.data?.byteIn ?? ""}, ${snapshot.data?.byteOut ?? ""}",
//                   textAlign: TextAlign.center),
//             ),
      
//             //sample vpn list
//             Column(
//                 children: _listVpn
//                     .map(
//                       (e) => ListTile(
//                         title: Text(e.country),
//                         leading: SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: Center(
//                               child: _selectedVpn == e
//                                   ? CircleAvatar(
//                                       backgroundColor: Colors.green)
//                                   : CircleAvatar(
//                                       backgroundColor: Colors.grey)),
//                         ),
//                         onTap: () {
//                           log("${e.country} is selected");
//                           setState(() => _selectedVpn = e);
//                         },
//                       ),
//                     )
//                     .toList())