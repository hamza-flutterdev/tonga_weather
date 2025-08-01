import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager extends GetxController {
  InterstitialAd? _currentAd;
  bool _isAdReady = false;
  var isShow = false.obs;

  int visitCounter = 0;
  final int displayThreshold = 3;

  @override
  void onInit() {
    super.onInit();
    _loadAd();
  }

  @override
  void onClose() {
    _currentAd?.dispose();
    super.onClose();
  }

  String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError("Platform not supported");
    }
  }

  void _loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _currentAd = ad;
          _isAdReady = true;
          update();
        },
        onAdFailedToLoad: (error) {
          _isAdReady = false;
          debugPrint("Interstitial load error: $error");
        },
      ),
    );
  }

  void _showAd() {
    if (_currentAd == null) return;
    isShow.value = true;
    _currentAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        isShow.value = false;
        _resetAfterAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("Interstitial failed: $error");
        ad.dispose();
        isShow.value = false;
        _resetAfterAd();
      },
    );

    _currentAd!.show();
    _currentAd = null;
    _isAdReady = false;
  }

  void checkAndDisplayAd() {
    visitCounter++;
    debugPrint("Visit count: $visitCounter");

    if (visitCounter >= displayThreshold) {
      if (_isAdReady) {
        _showAd();
      } else {
        debugPrint("Interstitial not ready yet.");
        visitCounter = 0;
      }
    }
  }

  void _resetAfterAd() {
    visitCounter = 0;
    _isAdReady = false;
    _loadAd();
    update();
  }
}
