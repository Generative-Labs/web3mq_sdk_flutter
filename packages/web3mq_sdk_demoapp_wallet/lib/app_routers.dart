import 'package:flutter/material.dart';
import 'package:web3mq_sdk_demoapp_wallet/main.dart';

import 'scan_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String scan = '/scan';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const MyHomePage(),
    scan: (context) => ScanPage(
          onScanResult: (List<String> results) {},
        ),
  };
}
