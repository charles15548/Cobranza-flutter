import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:negocio/db/db.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyProvider extends ChangeNotifier {
  double _moneda = 20.0;
  double get moneda => _moneda;
  final dbHelper = DatabaseHelper();

  MoneyProvider() {
    _cargarMoneda();
  }
  Future<void> _cargarMoneda() async {
    final obtener = await SharedPreferences.getInstance();
    _moneda = obtener.getDouble('moneda') ?? 20.0;
    notifyListeners();
  }

  Future<void> _guardarMoneda() async {
    final obtener = await SharedPreferences.getInstance();
    await obtener.setDouble('moneda', _moneda);
  }

  void restar(double cantidad) {
    _moneda -= cantidad;
    _guardarMoneda();
    notifyListeners();
  }

  void sumar(double cantidad) {
    _moneda += cantidad;
    _guardarMoneda();
    notifyListeners();
  }

  void showAnuncioRecompenza(BuildContext context) {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3503326553540884/6874164957',
        //adUnitId: 'ca-app-pub-3940256099942544/5224354917',  PRUEBA
        request: AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
            Provider.of<MoneyProvider>(context, listen: false).sumar(10);
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('¡+10 monedas! :D')));
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo cargar el anuncio')));
        }));
  }

  
}
