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
- `Somna/Views` — ekranlar: Onboarding, Bu gece, İstatistik, Sesler, Koç, Ayarlar
- `Somna/Resources` — Info.plist, Assets.xcassets

## Ürün yönü

- **Tamamen ücretsiz** — hiçbir özellik kilitli değil, ücret duvarı yok.
- **Kişiselleştirilmiş hedef**: onboarding'de yaş/boy/kilo/cinsiyet sorulur,
  National Sleep Foundation'ın yaş bazlı süre önerilerinden kişiye özel bir
  uyku hedefi hesaplanır (bkz. `Somna/Services/SleepGoalCalculator.swift`).
- **Ayarlar** ekranında profil düzenleme ve Gizlilik/Kullanım Şartları/Sağlık
  Bilgisi Açıklaması metinleri var.

Bu proje [[feedback_project_isolation]] kuralı gereği tamamen izole: AquaPulse,
Sound veya CastLane ile hiçbir dosya/kod paylaşmıyor.
