import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class ConnectivityProvider with ChangeNotifier{
  bool _isOnline=false;
  bool get isOnline => _isOnline;
    Connectivity connectivity=Connectivity();
  ConnectivityProvider(){
    connectivity.onConnectivityChanged.listen((event) {

      if(event==ConnectivityResult.none || event==ConnectivityResult.bluetooth){
        _isOnline=false;
        //notifyListeners();
      }else{
        _isOnline=true;
      }
        notifyListeners();
    });
  }
}