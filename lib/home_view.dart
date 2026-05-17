import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

class HomeView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final HarryPotterController dataController = Get.put(HarryPotterController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Aplikasi Harry Potter'),
          backgroundColor: Colors.pink.shade100,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => authController.logout(), 
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Characters'), 
              Tab(icon: Icon(Icons.auto_stories), text: 'Spells'), 
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CharacterSubView(controller: dataController),
            SpellsSubView(controller: dataController),
          ],
        ),
      ),
    );
  }
}

// --- SUB VIEW 1: CHARACTER LIST (Tampilan Card Sesuai Gambar Soal) ---
class CharacterSubView extends StatelessWidget {
  final HarryPotterController controller;
  const CharacterSubView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingChar.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: controller.characters.length,
        itemBuilder: (context, index) {
          var char = controller.characters[index];
          return Card(
            color: Colors.white, // Warna card putih bersih
            elevation: 1,
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Sudut melengkung halus
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () => Get.toNamed('/character_detail', arguments: char), 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Foto Karakter Berbentuk Kotak Melengkung
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        char['image'] ?? 'https://via.placeholder.com/150',
                        width: 50,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            char['fullName'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            char['interpretedBy'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class SpellsSubView extends StatelessWidget {
  final HarryPotterController controller;
  const SpellsSubView({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/favorite_spells'), 
        backgroundColor: Colors.pink.shade200,
        child: const Icon(Icons.favorite, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoadingSpells.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.spells.length,
          itemBuilder: (context, index) {
            var spell = controller.spells[index];
            String id = spell['index'].toString();
            
            // Menggunakan Obx internal di tingkat item agar perubahan warna love langsung responsif
            return Obx(() {
              bool fav = controller.isFavorite(id);
              return ListTile(
                leading: const Icon(Icons.bolt, color: Colors.amber),
                title: Text(spell['spell'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(spell['use'] ?? ''),
                trailing: IconButton(
                  icon: Icon(
                    fav ? Icons.favorite : Icons.favorite_border, 
                    color: fav ? Colors.red : Colors.grey, // Merah jika favorit, abu-abu jika tidak
                  ),
                  onPressed: () => controller.toggleFavorite(spell), 
                ),
              );
            });
          },
        );
      }),
    );
  }
}