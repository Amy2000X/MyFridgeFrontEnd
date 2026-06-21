import 'package:flutter/material.dart';

import '../models/grocery_item.dart';
import '../services/grocery_service.dart';

class GroceryListScreen
    extends StatefulWidget {
  const GroceryListScreen({
    super.key,
  });

  @override
  State<GroceryListScreen>
      createState() =>
          _GroceryListScreenState();
}

class _GroceryListScreenState
    extends State<GroceryListScreen> {

  late Future<List<GroceryItem>>
      futureItems;

  @override
  void initState() {
    super.initState();

    loadItems();
  }

  void loadItems() {
    futureItems =
        GroceryService.getItems();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Grocery List",
        ),
      ),
      body: FutureBuilder<
          List<GroceryItem>>(
        future: futureItems,
        builder:
            (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final items =
              snapshot.data!;

          if (items.isEmpty) {
            return const Center(
              child: Text(
                "No groceries yet",
              ),
            );
          }

          return ListView.builder(
            itemCount:
                items.length,
            itemBuilder:
                (context, index) {

              final item =
                  items[index];

              return ListTile(
                title: Text(
                  item.ingredient,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: () async {

                    await GroceryService
                        .deleteItem(
                      item.id,
                    );

                    setState(() {
                      loadItems();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}