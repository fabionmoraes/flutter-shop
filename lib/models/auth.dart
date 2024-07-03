import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/utils/constants.dart';

enum TypeUrl {
  login,
  signup,
}

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTime;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  void _clearAutoLogoutTimer() {
    _logoutTime?.cancel();
    _logoutTime = null;
  }

  void logout() {
    _token = null;
    _userId = null;
    _email = null;
    _expiryDate = null;
    _clearAutoLogoutTimer();

    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _autoLogout() {
    _clearAutoLogoutTimer();
    final timerToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;

    _logoutTime = Timer(
        Duration(
          seconds: timerToLogout ?? 0,
        ),
        logout);
  }

  Future<void> _authenticated(
      String email, String password, TypeUrl type) async {
    final url =
        type == TypeUrl.login ? Constants.signinUrl : Constants.signupUrl;

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(body['expiresIn']),
      ));

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expireDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();

      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expireDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expireDate;

    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return await _authenticated(email, password, TypeUrl.signup);
  }

  Future<void> login(String email, String password) async {
    return await _authenticated(email, password, TypeUrl.login);
  }
}
