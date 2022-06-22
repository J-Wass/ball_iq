// Project imports:
// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// TODO - add google ads

//import 'package:google_mobile_ads/google_mobile_ads.dart';
//AdWidget adWidget = AdWidget(ad: frontPageBannerAd);
//frontPageBannerAd.load();
/*
final BannerAd frontPageBannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
*/

class FrontPageAdvertisement extends StatelessWidget {
  FrontPageAdvertisement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: 50,
        width: MediaQuery.of(context).size.width - 20,
        child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.red.withOpacity(0.5))),
      ),
    );
  }
}// TODO Implement this library.
