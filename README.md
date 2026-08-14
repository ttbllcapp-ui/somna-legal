# Somna

Uyku ve akıllı alarm uygulaması. Native SwiftUI, XcodeGen ile üretiliyor.

Tasarım konsepti ve renk/tipografi kararları için [docs/design-concept.md](docs/design-concept.md).

## Kurulum

```bash
brew install xcodegen   # zaten kurulu değilse
cp Signing.xcconfig.example Signing.xcconfig   # ekibinize özel Apple Developer Team ID'sini girin
xcodegen generate
open Somna.xcodeproj
```

Simulator derlemeleri `Signing.xcconfig` boş bırakılsa bile çalışır — bir takım
kimliği sadece gerçek cihaza kurulum için gerekli.

## Yapı

- `Somna/App` — uygulama giriş noktası (`SomnaApp.swift`)
- `Somna/Theme` — renk paleti, tipografi, ortak view modifier'lar
- `Somna/Views` — ekranlar: Bu gece (skor), Evreler, Sesler, Koç, Somna+
- `Somna/Resources` — Info.plist, Assets.xcassets

## Ürün yönü

- **Ücretsiz katman**: uyku skoru, evreler, uyandırma görevi, uyku koçu (Health/Watch
  entegrasyonlu), sınırsız kullanım.
- **Somna+ (Pro)**: genişletilmiş ses kütüphanesi, uzun geçmiş + dışa aktarım,
  özel uyandırma görevi fotoğrafları. Koç asla ücret duvarının arkasına
  girmiyor — bu bilinçli bir ürün kararı.

Bu proje [[feedback_project_isolation]] kuralı gereği tamamen izole: AquaPulse,
Sound veya CastLane ile hiçbir dosya/kod paylaşmıyor.
