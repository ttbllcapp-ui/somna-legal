# Somna — tasarım konsepti

Rakip analizi (Tock, Alarmy, Sleep Cycle, RISE, SleepWatch, Pillow, AutoSleep,
Eight Sleep, SleepScore) ve tasarım pitch'i bu konuşmada üretildi. Palet ve
ekran kararları burada özetleniyor; canlı HTML mockup ayrı olarak paylaşıldı.

## Renk

| Rol | Hex |
|---|---|
| Zemin (ink) | `#070f16` |
| Kart | `#13222c` |
| Çizgi (hair) | `#26404f` |
| Metin | `#f4f8f9` / `#a6b8c2` / `#71879e` |
| Vurgu (şafak amberi) | `#f2a65a` |
| Derin uyku | `#6577f2` |
| Hafif uyku | `#39b8ac` |
| REM | `#8fe8da` |
| Uyanık | `#e2905a` |
| Ücretsiz rozet | `#4fd3b8` |

Tock'un mor-lavanta paletinden bilinçli olarak uzaklaşıldı: sabit gece mavisi
zemin + tek sıcak vurgu rengi, tüm "uyanma" anlarını (skor halkası, görev
ekranı, koç kartı) işaretliyor.

## Tipografi

- Başlıklar: serif (Georgia ailesi / `ui-serif`) — kategoride herkes kalın
  sans kullanıyor (Alarmy, Tock, Sleep Cycle), serif "kitap/masal" hissiyle
  farklılaşıyor.
- Gövde ve veri: sistem sans + mono (tabular figures).

## Ürün / monetizasyon

- Uyku koçu **her zaman ücretsiz** — Apple Health + Apple Watch verisini okuyup
  konuşuyor, bu Somna'nın elinde tutma sebebi.
- Somna+ sadece hacim satıyor: 50+ ses, 1 yıllık geçmiş, özel görev fotoğrafı.

## Ekranlar

1. Bu gece (skor halkası, Health/Watch rozetleri, süre/verimlilik kartları)
2. Uyandırma görevi (kamera viewfinder, nesne eşleştirme, geri sayım)
3. Uyku evreleri (stacked bar + lejant, gerçek/tahmini ayrımı açık)
4. Sesler (katmanlı ses karıştırıcı, 3 ücretsiz + Somna+ ile 50+)
5. Koç (sohbet + gömülü veri kartı)
6. Somna+ (ücretsiz vs pro plan kartları)

## Sonraki adımlar

- Gerçek Apple Health / HealthKit okuma entegrasyonu
- Gerçek kamera + Vision framework ile nesne eşleştirme
- RevenueCat paywall entegrasyonu (AquaPulse'taki desenle aynı, ama kod
  paylaşılmadan — [[feedback_project_isolation]])
- Uygulama ikonu ve gerçek marka kimliği
