import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.onScanResult});

  // on handle scan result
  final void Function(List<String> results) onScanResult;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      // fit: BoxFit.contain,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        // map barcodes to string
        final List<String> results = barcodes.map((e) => e.rawValue!).toList();
        widget.onScanResult(results);
      },
    );
  }
}
