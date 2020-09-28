import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  DateTime _expiryDate;
  String _token;
  String _userId;
  Timer _logoutTimer;

  bool get isAuth{
    return this.token != null;
  }

  String get userId{
    return this.isAuth ? this._userId : null;
  }

  String get token {
    if (this._expiryDate != null &&
        this._token != null &&
        this._expiryDate.isAfter(DateTime.now())) {
      return this._token;
    } else {
      return null;
    }
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBLA2t66oRMr8otV_TdxX8wW4pLWywwEfg';

    final response = await http.post(
      _url,
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final responseBody = json.decode(response.body);
    if (responseBody['error'] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      this._token = responseBody['idToken'];
      this._expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
      this._userId = responseBody['localId'];

      Store.saveMap('userData', {
        'token': this._token,
        'userId': this._userId,
        'expiryDate': this._expiryDate.toIso8601String()
      });

      this._autoLogout();
      notifyListeners();
    }

    Future.value();
  }

  Future<void> tryAutologin() async{
    if(this.isAuth) return Future.value();

    final userData = await Store.getMap('userData');

    if(userData == null) return Future.value();

    final expiryDate = DateTime.parse(userData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())) return Future.value();

    this._token = userData['token'];
    this._userId = userData['userId'];
    this._expiryDate = expiryDate;

    this._autoLogout();
    notifyListeners();
    
    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return this.authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return this.authenticate(email, password, 'signInWithPassword');
  }

  void logout(){
    this._token = null;
    this._userId = null;
    this._expiryDate = null;
    if(this._logoutTimer != null){
      this._logoutTimer.cancel();
      this._logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout(){
    if(this._logoutTimer != null){
      this._logoutTimer.cancel();
    }
    final timeToLogout = this._expiryDate.difference(DateTime.now()).inSeconds;
    this._logoutTimer = Timer(Duration(seconds: timeToLogout), this.logout);
  }
}
