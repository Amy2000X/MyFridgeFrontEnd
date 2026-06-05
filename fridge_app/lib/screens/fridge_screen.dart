import 'package:flutter/material.dart';
import '../services/fridge_service.dart';

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({
    super.key,
  });

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen> {
  List<dynamic> items = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final result = await FridgeService.getItems();

      setState(() {
        items = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });

      print('Error loading items: $e');
    }
  }

  Future<void> refreshItems() async {
    await loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Fridge'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage),
                )
              : items.isEmpty
                  ? const Center(
                      child: Text(
                        'No fridge items found',
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: refreshItems,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              title: Text(
                                item['name'] ?? '',
                              ),
                              subtitle: Text(
                                '${item['quantity']} ${item['unit']}',
                              ),
                              trailing: Text(
                                item['status'] ?? '',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}