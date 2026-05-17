import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CharacterDetailView extends StatelessWidget {
  const CharacterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Menerima data objek karakter yang dikirimkan lewat navigasi Get.toNamed
    final Map char = Get.arguments;

    // Pengecekan nama lengkap dari beberapa kemungkinan key API
    final String fullName = char['character'] ?? char['name'] ?? char['fullName'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: Text(fullName != '-' ? fullName : 'Detail Karakter'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // 1. Foto Karakter Utama
              Hero(
                tag: 'avatar_${char['index'] ?? fullName}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    char['image'] ?? 'https://via.placeholder.com/150',
                    height: 280,
                    width: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 280,
                        width: 220,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.person, size: 80, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // 2. Kartu Informasi Seluruh Properti Karakter
              Card(
                color: const Color(0xFFFFF0F5), // Latar belakang card lavender pink pastel imut
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 8),
                          Text(
                            'Biodata',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      
                      // Menampilkan semua property data karakter satu per satu 
                      _buildDetailRow(Icons.badge, 'Full Name', fullName),
                      _buildDetailRow(Icons.face, 'Nickname', char['nickname']),
                      
                      // MENAMBAHKAN BARIS BIRTHDATE DI SINI
                      _buildDetailRow(Icons.cake, 'Birthdate', char['birthdate']),
                      
                      _buildDetailRow(Icons.home, 'Hogwarts House', char['hogwartsHouse']),
                      _buildDetailRow(Icons.movie, 'Interpreted By', char['interpretedBy']),
                      
                      // Menangani properti 'children' yang berupa Array/List menjadi teks String rata
                      _buildDetailRow(
                        Icons.child_care, 
                        'Children', 
                        (char['children'] is List && (char['children'] as List).isNotEmpty)
                            ? (char['children'] as List).join(', ')
                            : '-',
                      ),
                      
                      // Menambahkan index atau ID karakter jika dibutuhkan untuk kelengkapan data
                      _buildDetailRow(Icons.numbers, 'Character Index', char['index']?.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk membuat baris detail yang rapi dan konsisten dengan ikon
  Widget _buildDetailRow(IconData icon, String title, String? val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.pink.shade300),
          const SizedBox(width: 12),
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          const Text(':', style: TextStyle(color: Colors.black54)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              (val == null || val.trim().isEmpty || val == 'null') ? '-' : val,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}