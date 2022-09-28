import 'package:demo_ads/banneradd.dart';
import 'package:demo_ads/interad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MaterialApp(
    home: InterPage(),
  ));
}

const int maxFailedLoadAttempts = 3;



//steps native ads
//setting.gradle
//android/app/src/main/java/com/mainactivity-javaclass()
//android/app/src/main/res/layout-directory/add file