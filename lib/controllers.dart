import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'main.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;

  void login(String username, String password) async {
    if (username == 'Dila' && password == 'dila123') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('username', username);
      isLoggedIn.value = true;
      
      Get.offAllNamed('/home');
      Get.snackbar('Success', 'Selamat Datang, $username!',
          backgroundColor: Colors.green, colorText: Colors.white); 
    } else {
      Get.snackbar('Failed', 'Username atau Password salah.',
          backgroundColor: Colors.red, colorText: Colors.white); 
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
    Get.snackbar('Logout', 'Berhasil keluar dari akun.',
        backgroundColor: Colors.green, colorText: Colors.white); 
  }
}

class HarryPotterController extends GetxController {
  var characters = [].obs;
  var spells = [].obs;
  var isLoadingChar = true.obs;
  var isLoadingSpells = true.obs;
  var favoriteBox = Hive.box('favorite_spells').obs;

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();
    fetchSpells();
  }

  void fetchCharacters() async {
    try {
      isLoadingChar(true);
      var response = await http.get(Uri.parse('https://potterapi-fedeperin.vercel.app/en/characters'));
      if (response.statusCode == 200) {
        characters.value = json.decode(response.body);
      }
    } finally {
      isLoadingChar(false);
    }
  }

  void fetchSpells() async {
    try {
      isLoadingSpells(true);
      var response = await http.get(Uri.parse('https://potterapi-fedeperin.vercel.app/en/spells')); 
      if (response.statusCode == 200) {
        spells.value = json.decode(response.body);
      }
    } finally {
      isLoadingSpells(false);
    }
  }

  bool isFavorite(String spellId) {
    return favoriteBox.value.containsKey(spellId);
  }

  void toggleFavorite(Map spell) {
    String id = spell['index'].toString();
    if (isFavorite(id)) {
      favoriteBox.value.delete(id);
      Get.snackbar('Removed', '${spell['spell']} dihapus dari favorit.',
          backgroundColor: Colors.red, colorText: Colors.white); 
    } else {
      favoriteBox.value.put(id, spell);
      Get.snackbar('Added', '${spell['spell']} ditambahkan ke favorit.',
          backgroundColor: Colors.green, colorText: Colors.white); 
    }
    favoriteBox.refresh();
  }

  void removeFavoriteWithNotification(Map spell) async {
    String id = spell['index'].toString();
    favoriteBox.value.delete(id);
    favoriteBox.refresh();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'spell_channel_id',
      'Spell Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Spell Notification',
      'You Deleted ${spell['spell']} From your List Item!',
      platformChannelSpecifics,
    );
  }
}