import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdMobServicesProvider with ChangeNotifier {
  // static const String _bannerIdAndroid =
  //     'ca-app-pub-3940256099942544/1033173712';
  // static const String _bannerIdIOS = 'ca-app-pub-3940256099942544/4411468910';

  bool _isBannerAdVisible = false;
  bool get isBannerAdVisible => _isBannerAdVisible;
  BannerAd? _bannerAd;
  BannerAd? get bannerAd => _bannerAd;

  // String? get _bannerId {
  //   if (Platform.isAndroid) {
  //     return _bannerIdAndroid;
  //   } else if (Platform.isIOS) {
  //     return _bannerIdIOS;
  //   } else {
  //     return null;
  //   }
  // }

  void setIsBannerAdLoaded(bool value) {
    _isBannerAdVisible = value;
    notifyListeners();
  }

  void loadBanner() {
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716';
    final bannerAd = BannerAd(
        adUnitId: adUnitId,
        request: const AdRequest(),
        size: AdSize(
            height: 60,
            width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .size
                .width
                .toInt()),
        listener: BannerAdListener(onAdLoaded: (ad) {
          _bannerAd = ad as BannerAd?;
          _isBannerAdVisible = true;
          notifyListeners();
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isBannerAdVisible = false;
          notifyListeners();
        }, onAdOpened: (ad) {
          // add open
        }, onAdClosed: (ad) {
          // add Close
        }));
    bannerAd.load();
  }

  // BannerAd showBanner() {
  //   var myBanner = BannerAd(
  //       adUnitId: _bannerId!,
  //       size: AdSize(
  //           height: 60,
  //           width: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
  //               .size
  //               .width
  //               .toInt()),
  //       request: const AdRequest(),
  //       listener: BannerAdListener(onAdLoaded: (ad) {
  //         _isBannerAdVisible = true;
  //         print('Ad loaded $_isBannerAdVisible');
  //         notifyListeners();
  //       }, onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //         _isBannerAdVisible = false;
  //         print('Failed to load Ad');
  //         notifyListeners();
  //       }, onAdOpened: (ad) {
  //         print('Ad opend');
  //         // add open
  //       }, onAdClosed: (ad) {
  //         print('Ad closed');
  //         // add Close
  //       }));
  //   return myBanner;
  // }

  // static const String _interstitialIdAndroid = "ca-app-pub-3940256099942544/1033173712";
  // static const String _interstitialIdIOS = "ca-app-pub-3940256099942544/4411468910";
  // static const String _rewardedIdAndroid = "ca-app-pub-3940256099942544/5224354917";
  // static const String _rewardedIdIOS = "ca-app-pub-3940256099942544/1712485313";
  // bool isRewardedAdLoaded  = false;

  // RewardedAd? _rewardedAd;
  // InterstitialAd? _interstitialAd;

  // RewardedAd? get rewardedAd => _rewardedAd;
  // InterstitialAd? get interstitialAd => _interstitialAd;

  // String? get _interstitialId{
  //   if(Platform.isAndroid){
  //     return _interstitialIdAndroid;
  //   }else if(Platform.isIOS){
  //     return _interstitialIdIOS;
  //   }else{
  //     return null;
  //   }
  // }

  // String? get _rewardedId{
  //   if(Platform.isAndroid){
  //     return _rewardedIdAndroid;
  //   }else if(Platform.isIOS){
  //     return _rewardedIdIOS;
  //   }else{
  //     return null;
  //   }
  // }

  // void loadRewardedAd(BuildContext context) {
  //   RewardedAd.load(
  //     adUnitId: _rewardedId!,
  //     request:const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdFailedToLoad: (LoadAdError error){
  //         print("Failed to load rewarded ad, Error: $error");
  //         _rewardedAd = null;
  //       },
  //       //when loaded
  //       onAdLoaded: (RewardedAd ad){
  //         print("$ad loaded");
  //         _rewardedAd = ad;
  //         setFullScreenContentCallbackForRewardedAd(context);

  //       },
  //     ),
  //   );
  // }

  // void setFullScreenContentCallbackForRewardedAd(BuildContext context){
  //   if(_rewardedAd == null) return;
  //   _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     //when ad  shows fullscreen
  //     onAdShowedFullScreenContent: (RewardedAd ad) => print("$ad onAdShowedFullScreenContent"),
  //     //when ad dismissed by user
  //     onAdDismissedFullScreenContent: (RewardedAd ad){
  //       print("$ad onAdDismissedFullScreenContent");
  //       //dispose the dismissed ad
  //       ad.dispose();
  //       loadRewardedAd(context);
  //     },
  //     //when ad fails to show
  //     onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error){
  //       print("$ad  onAdFailedToShowFullScreenContent: $error ");
  //       //dispose the failed ad
  //       ad.dispose();
  //       loadRewardedAd(context);
  //     },
  //     //when impression is detected
  //     onAdImpression: (RewardedAd ad) =>print("$ad Impression occured"),
  //   );

  // }

  // //show ad method
  // void showRewardedAd(BuildContext context){
  //   //this method take a on user earned reward call back
  //   if(_rewardedAd != null){
  //     _rewardedAd!.show(
  //       //user earned a reward
  //         onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem){
  //           context.read<ProfileProvider>().getFreeReward(rewardItem.amount.toInt(),context);
  //           context.read<ProfileProvider>().setOutOfCoins(false);
  //           context.read<RewardsProvider>().rewardCollected(context);
  //           //reward user for watching your ad
  //           num amount = rewardItem.amount;
  //           print("You earned: $amount");
  //         }
  //     );
  //   }
  //   _rewardedAd = null;
  // }

  // void loadInterstitialAd(){
  //   InterstitialAd.load(
  //       adUnitId: _interstitialId!,
  //       request: const AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //         onAdLoaded: (InterstitialAd ad) {
  //           _interstitialAd = ad;
  //           setFullScreenContentCallbackInterstitialAd();
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           _interstitialAd = null;
  //         },
  //       ));
  // }

  // void setFullScreenContentCallbackInterstitialAd(){
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (InterstitialAd ad){
  //       print("$ad onAdShowedFullScreenContent");
  //     },
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //       loadInterstitialAd();
  //     },
  //     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
  //       ad.dispose();
  //       loadInterstitialAd();
  //     },
  //     onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
  //   );
  // }

  // void showInterstitialAd(){
  //   if(_interstitialAd != null){
  //     _interstitialAd!.show();
  //   }
  // }
}
