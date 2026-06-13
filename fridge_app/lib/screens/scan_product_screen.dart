import 'package:flutter/material.dart';
import 'package:fridge_app/screens/home_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/fridge_service.dart';

class ScanProductScreen extends StatefulWidget {
  const ScanProductScreen({super.key});

  @override
  State<ScanProductScreen> createState() => _ScanProductScreenState();
}

class _ScanProductScreenState extends State<ScanProductScreen> {
  final MobileScannerController controller = MobileScannerController(
    facing: CameraFacing.back,
  );

  bool scanned = false;
  String errorMessage = "Cannot read the barcode";

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Product"),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (scanned) return;

          final barcode = capture.barcodes.first;
          debugPrint('format=${barcode.format} value=${barcode.rawValue}',);
          final String? ean = barcode.rawValue;
          debugPrint('format=${barcode.format} value=${barcode.rawValue.toString()}',);
          debugPrint('format=${barcode.format} ean value=${ean}',);

          if (ean == null) return;

          errorMessage = "Item could not be found";
          scanned = true;

          await controller.stop();

          try {
            await FridgeService.scanBarcode(ean);

            if (!mounted) return;

            final result = await showDialog<String>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text("Success"),
                content: const Text(
                  "Product scanned successfully",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, 'home'),
                    child: const Text("Home"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, 'scan'),
                    child: const Text("Scan"),
                  ),
                ],
              ),
            );
            if (result == 'home') {
              // Navigator.pushNamed(context, '/home');
              // // or:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else {
              // User chose "Scan" -> restart scanner
              scanned = false;
              await controller.start();
              return;
            }

          } catch (e) {
            if (!mounted) return;
            

            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Error"),
                content: Text(
                  errorMessage,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }

          scanned = false;
          await controller.start();
        },
      ),
    );
  }
}