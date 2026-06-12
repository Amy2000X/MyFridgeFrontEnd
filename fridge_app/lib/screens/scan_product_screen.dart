import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/fridge_service.dart';

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({super.key});

  @override
  State<ScanProductScreen> createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {

  bool scanned = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Product"),
      ),

      body: MobileScanner(

        controller: MobileScannerController(
          facing: CameraFacing.back,
        ),

        onDetect: (capture) async {

          if (scanned) return;

          final barcode = capture.barcodes.first;

          final ean = barcode.rawValue;

          if (ean == null) return;

          scanned = true;

          try {

            await FridgeService.scanBarcode(ean);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Product scanned successfully"),
                ),
              );

              Navigator.pop(context, true);
            }

          } catch (e) {

            scanned = false;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
              ),
            );

          }

        },
      ),
    );
  }
}