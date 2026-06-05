import 'package:flutter/material.dart';

class ScanProductScreen extends StatelessWidget {
  const ScanProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Product'),
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            // Open scanner
          },
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Scan Barcode'),
        ),
      ),
    );
  }
}