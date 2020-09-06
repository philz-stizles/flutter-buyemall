import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buyemall/models/user.dart';
import 'package:buyemall/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';
  final String _key = 'AIzaSyCogQhuWplaMRIm6VvSzm3XajKinYNkVsk';
  final String _signUpEndpoint = ':signUp?key=';
  final String _signInEndpoint = ':signInWithPassword?key=';
  var _authIsLoading = false;
  User _authenticatedUser;
  Timer _tokenExpirationTimer;

  bool get authIsLoading {
    return _authIsLoading;
  }

  String get token {
    return (_authenticatedUser == null)
        ? null
        : (_authenticatedUser.token == null ||
                _authenticatedUser.expiresIn == null)
            ? null
            : (DateTime.now().isAfter(_authenticatedUser.expiresIn))
                ? null
                : _authenticatedUser.token;
  }

  bool get isAuthenticated {
    print(token);
    return (token != null);
  }

  User get authenticatedUser {
    return _authenticatedUser;
  }

  Future<void> signUp(Map<String, dynamic> userCredentials) async {
    _authIsLoading = true;
    print(userCredentials);
    notifyListeners();

    userCredentials["returnSecureToken"] = true;
    print(userCredentials);

    try {
      var response = await http.post(_baseUrl + _signUpEndpoint + _key,
          body: json.encode(userCredentials),
          headers: {'Content-Type': 'application/json'});

      var responseData = json.decode(response.body);
      print(response.statusCode);
      print(responseData);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw (error);
    }
  }

  Future<void> signIn(Map<String, dynamic> userCredentials) async {
    userCredentials["returnSecureToken"] = true;
    print(userCredentials);
    print(_baseUrl + _signInEndpoint + _key);

    try {
      var response = await http.post(_baseUrl + _signInEndpoint + _key,
          body: json.encode(userCredentials),
          headers: {'Content-Type': 'application/json'});

      var responseData = json.decode(response.body);
      print(response.statusCode);

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _authenticatedUser = new User(
          userId: responseData['localId'],
          email: responseData['email'],
          token: responseData['idToken'],
          expiresIn: DateTime.now().add(Duration(
              seconds: int.parse(
                  responseData['expiresIn']))) // This is returned in form of
          // a string which needs to be parsed into an int so that it can be
          // added
          );
      _autoLogoutTimer();
      notifyListeners();
      final store = await SharedPreferences.getInstance();
      store.setString('storedUser', json.encode(_authenticatedUser.toJson()));
      print(store.getString('storedUser'));
    } catch (error) {
      throw (error);
    }
  }

  Future<void> logOut() async {
    _authenticatedUser = User();
    if (_tokenExpirationTimer != null) {
      _tokenExpirationTimer.cancel();
      _tokenExpirationTimer = null;
    }

    notifyListeners();
    final store = await SharedPreferences.getInstance();
    store.remove('storedUser');
    print(store.getString('storedUser'));
  }

  void _autoLogoutTimer() {
    if (_tokenExpirationTimer != null) {
      _tokenExpirationTimer.cancel();
    }

    final tokenExpirationSeconds =
        _authenticatedUser.expiresIn.difference(DateTime.now()).inSeconds;
    _tokenExpirationTimer =
        Timer(Duration(seconds: tokenExpirationSeconds), logOut);
  }

  Future<bool> tryAutoLogin() async {
    final store = await SharedPreferences.getInstance();
    if (!store.containsKey('storedUser')) {
      return false;
    }

    final storedEncodedUser = store.getString('storedUser');
    final storedUser = json.decode(storedEncodedUser) as Map<String, Object>;
    final expiresIn = DateTime.parse(storedUser['expiresIn']);
    print('try autologin');
    print(storedUser['userId']);

    if (expiresIn.isBefore(DateTime.now())) {
      return false;
    }

    _authenticatedUser = new User(
        userId: storedUser['userId'],
        email: storedUser['email'],
        token: storedUser['token'],
        expiresIn: expiresIn // This is returned in form of
        // a string which needs to be parsed into an int so that it can be
        // added
        );
    notifyListeners();
    _autoLogoutTimer();

    return true;
  }
}
