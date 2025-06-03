
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Anunciobanner extends StatefulWidget {
  final String idAnuncio;
  const Anunciobanner({Key? key, required this.idAnuncio}) : super(key: key);
  
  @override
  State<Anunciobanner> createState() => _AnunciobannerState();
}

class _AnunciobannerState extends State<Anunciobanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState(){
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: widget.idAnuncio,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      )..load();
  }

   @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return SizedBox();
    return SizedBox(
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}