import 'package:flutter/material.dart';
import 'package:web3mq_sdk_demoapp_wallet/main.dart';

import 'scan_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String scan = '/scan';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const MyHomePage(title: 'Home Page'),
    scan: (context) => ScanPage(
          title: 'Scan QR Code',
          onScanResult: (List<String> results) {},
        ),
  };
}
