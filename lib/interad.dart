import 'dart:io';
import 'package:demo_ads/app_lifecycle_reactor.dart';
import 'package:demo_ads/app_open_ad_manager.dart';
import 'package:demo_ads/banneradd.dart';
import 'package:demo_ads/main.dart';
import 'package:demo_ads/nativepage.dart';
import 'package:demo_ads/rewardpage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterPage extends StatefulWidget {
  const InterPage({Key? key}) : super(key: key);

  @override
  State<InterPage> createState() => _InterPageState();
}

class _InterPageState extends State<InterPage> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int inter = 0;

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      if (inter == 1) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return BannerPage();
          },
        ));
      }
      else if (inter == 2) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return RewardPage();
          },
        ));
      }
      else if (inter == 3) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return NativePage();
          },
        ));
      }
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        //** Navigator **//
        if (inter == 1) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return BannerPage();
            },
          ));
        }
        else if (inter == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return RewardPage();
            },
          ));
        }
        else if (inter == 3) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return NativePage();
            },
          ));
        }
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("interstitial page"),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                inter = 1;
                _showInterstitialAd();
              },
              child: Text("Banner Page")),
          ElevatedButton(
              onPressed: () {
                inter = 2;
                _showInterstitialAd();
              },
              child: Text("Reward Page")),
          ElevatedButton(
              onPressed: () {
                inter = 3;
                _showInterstitialAd();
              },
              child: Text("Native Page"))
        ],
      ),
    );
  }
}
