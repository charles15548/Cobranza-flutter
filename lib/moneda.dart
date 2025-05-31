
import 'package:flutter/material.dart';

class MoneyProvider extends ChangeNotifier{
  double _moneda = 1000.0;
  double get moneda => _moneda;

  void restar(double cantidad){
    _moneda -=cantidad;
    notifyListeners();
  }

  void sumar(double cantidad){
    _moneda -=cantidad;
    notifyListeners();
  }

}