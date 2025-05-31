import 'package:flutter/material.dart';
import 'package:negocio/moneda.dart';
import 'package:negocio/negocios.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();


  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MoneyProvider())
    ]
    ,child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Negocios(),
      debugShowCheckedModeBanner: false,
    );
  }
}