import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:negocio/negocios.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

   void _showRewardedAd(BuildContext context) {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3503326553540884/6874164957', 
      // adUnitId: 'ca-app-pub-3940256099942544/5224354917',  PRUEBA
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
              // Aquí recompensa al usuario
                Provider.of<MoneyProvider>(Context,listen: false).sumar(100);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('¡Recompensa obtenida!')),
              );
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo cargar el anuncio')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Negocios()),
                );
              },
              icon: Icon(Icons.storefront,size: 29,),
              tooltip: 'Inicio',
            ),
            SizedBox(
              width: 40,
            ),
            IconButton(
              onPressed: () => _showRewardedAd(context),
              icon: Icon(Icons.settings,size: 29,),
              tooltip: 'Configuración',
            )
          ],
        ));
  }
}
