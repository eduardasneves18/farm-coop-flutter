import 'dart:async';
import 'package:flutter/material.dart';
import '../../../models/cliente.dart';
import '../../../services/cache/transaction_cache_service.dart';
import '../../../services/cache/products/product_cache_service.dart';
import 'package:yes_bank/main.dart';

import '../users/login/login_firebase.dart';


class SessionManager {
  static const Duration sessionTimeout = Duration(seconds: 10);
  Timer? _sessionTimer;

  final LoginFirebaseAuthService _authService;
  final Cliente _user;
  final ClienteStore _clienteStore;
  final ProductCacheService _cacheService = ProductCacheService();

  SessionManager(this._authService, this._user, this._clienteStore) {
    _startSessionTimer();
    _setUser();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(sessionTimeout, _handleSessionTimeout);
  }

  void resetSessionTimer() {
    _startSessionTimer();
  }

  void _setUser() {
    _clienteStore.defineCliente(_user);
  }

  void _clearUser() {
    _clienteStore.removeCliente();
  }

  Future<void> _handleSessionTimeout() async {
    await logout();
  }

  Future<void> logout() async {
    _sessionTimer?.cancel();
    await _authService.signOut();
    _clearUser();
    await _cacheService.clearCache();

    // navigatorKey.currentState?.pushReplacement(
    //   MaterialPageRoute(builder: (_) => ListTransactions()),
    // );

  }

  void dispose() {
    _sessionTimer?.cancel();
  }
}
