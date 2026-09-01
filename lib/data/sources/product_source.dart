import '../models/catalog.dart';

/// Bir ürün veri kaynağının sözleşmesi. Farklı API'ler (wantapi, DummyJSON)
/// bu arayüzü uygular; repository hangisinin kullanılacağını bilmez.
abstract interface class ProductSource {
  /// Ayarlar ekranında gösterilecek okunabilir ad.
  String get label;

  /// Ürünleri çeker. Hata olursa exception fırlatır (repository yakalar).
  Future<Catalog> fetch();
}

/// Kullanılabilir uzak kaynaklar.
enum ProductSourceKind {
  wantApi('WANTAPI (varsayılan)'),
  dummyJson('DummyJSON');

  const ProductSourceKind(this.label);
  final String label;
}
