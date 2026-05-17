import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

class FavoriteSpellsView extends StatelessWidget {
  final HarryPotterController controller = Get.find<HarryPotterController>();

  FavoriteSpellsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spells'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Obx(() {
        var favItems = controller.favoriteBox.value.values.toList();
        if (favItems.isEmpty) {
          return const Center(
            child: Text('Belum ada mantra favorit.', style: TextStyle(fontStyle: FontStyle.italic)),
          );
        }
        return ListView.builder(
          itemCount: favItems.length,
          itemBuilder: (context, index) {
            var spell = favItems[index] as Map;
            return ListTile(
              leading: const Icon(Icons.star, color: Colors.redAccent),
              title: Text(spell['spell'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(spell['use'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.removeFavoriteWithNotification(spell), 
              ),
            );
          },
        );
      }),
    );
  }
}