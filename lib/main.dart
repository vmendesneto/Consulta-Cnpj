import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:consulta_cnpj/screen/import_excel_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _startMonitoringConnectivity();
  }

  void _startMonitoringConnectivity() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _connectivity.checkConnectivity().then(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _isOnline = result != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isOnline ? ExcelImportScreen() : OfflineScreen(),
    );
  }
}

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline'),
      ),
      body: const Center(
        child: Text('Você está offline. Por favor, verifique sua conexão.'),
      ),
    );
  }
}
