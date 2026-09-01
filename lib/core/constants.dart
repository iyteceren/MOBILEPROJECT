import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan metinler. Tek yerden yönetilir; ileride
/// çoklu dil desteği eklenecekse buradan `intl`'e taşınır.
class AppStrings {
  AppStrings._();

  static const appTitle = 'Budget Build';
  static const homeSubtitle =
      'Sabit bir bütçeyle hayalindeki Apple kurulumunu oluştur.';
  static const chooseBudget = 'Bütçeni seç';
  static const catalog = 'Katalog';
  static const yourBuild = 'Senin Kurulumun';
  static const result = 'Sonuç';
  static const compare = 'Karşılaştır';
  static const favorites = 'Favoriler';
  static const savedBuilds = 'Kayıtlı Kurulumlar';
  static const settings = 'Ayarlar';

  static const addToBuild = 'Kuruluma Ekle';
  static const removeFromBuild = 'Kurulumdan çıkar';
  static const budgetTooLow = 'Bütçe yetersiz';
  static const completeBuild = 'Kurulumu Tamamla';
  static const newBuild = 'Yeni kurulum';
  static const saveBuild = 'Kurulumu kaydet';

  static const searchHint = 'Ürün ara';
  static const emptyBuildTitle = 'Kurulumun boş';
  static const emptyBuildBody = 'Katalogdan ürün ekleyerek başla.';
  static const loadError = 'Ürünler yüklenemedi.';
  static const retry = 'Tekrar dene';
  static const offlineNotice = 'Çevrimdışı veri gösteriliyor';
}

/// Ölçü sabitleri: boşluk, köşe yarıçapı, ikon boyutları. "Magic number"
/// kullanımını azaltır ve tutarlı bir ritim sağlar.
class AppSizes {
  AppSizes._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 28;

  static const double radius = 14;
  static const double cardRadius = 16;

  static const double buttonHeight = 52;
  static const double gridMaxExtent = 220;
}

/// Renk paleti.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF0A84FF);

  // Light
  static const bgLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF4F4F6);
  static const textLight = Color(0xFF11131A);
  static const textMutedLight = Color(0xFF8A8F98);

  // Dark
  static const bgDark = Color(0xFF0B0B0D);
  static const surfaceDark = Color(0xFF1B1C1F);
  static const textDark = Color(0xFFF2F3F5);
  static const textMutedDark = Color(0xFF8A8F98);
}
