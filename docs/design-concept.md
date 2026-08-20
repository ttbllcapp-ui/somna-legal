# Somna — tasarım konsepti

Rakip analizi (Tock, Alarmy, Sleep Cycle, RISE, SleepWatch, Pillow, AutoSleep,
Eight Sleep, SleepScore) ve tasarım pitch'i bu konuşmada üretildi. Palet ve
ekran kararları burada özetleniyor; canlı HTML mockup ayrı olarak paylaşıldı.

## 2026-08-21: tasarım pivotu — koyu/atmosferik → açık/kalın/oyunlaştırılmış

İlk üç tasarım turu (koyu lacivert minimal, sonra atmosferik gradient +
glassmorphism) kullanıcı tarafından beğenilmedi ("çok basit", "soft").
Kullanıcı açıkça kanıtlanmış bir rakibi kopyalamamı istedi: canlı App Store
verisiyle bulunan **PushClock** (`com.WinToday.PushClock`) — ~5 ay önce
yayınlanmış, 5.712 rating / 4.68 ⭐ (kategoride bulunan en hızlı büyüyen yeni
app). PushClock'un ekran görüntüleri incelendi ve tasarım sistemi tamamen
zıt çıktı: **açık gri zemin, kalın siyah yuvarlatılmış sans tipografi,
renkli rozet etiketler, streak/trophy oyunlaştırma, yüksek kontrast düz beyaz
kartlar** — atmosferik/moody değil, PushClock resmi/pazarlama dili "aggressive
utility app" gibi.

Somna'nın teması bu prensiplere göre yeniden yazıldı (bkz. `Theme.swift`):

| Rol | Hex |
|---|---|
| Zemin | `#F1F0F6` (açık gri) |
| Kart | `#FFFFFF` |
| Metin | `#15141C` / `#66646F` / `#9997A2` |
| Vurgu (Somna marka rengi) | `#5B4FEE` (indigo — PushClock'un yeşilinin birebir kopyası değil, aynı "tek yüksek kontrast renk" mantığı) |
| Başarı/streak | `#1FAA59` |
| Mercan | `#FF6152` |
| Nane | `#2FCCB8` |
| Altın | `#FFB020` |
| Lavanta | `#9C8CFF` |

## Tipografi

- Başlıklar ve büyük sayılar: `.system(design: .rounded)`, `.heavy`/`.bold`
  ağırlık — PushClock'un imza stili: büyük, siyah, gözden kaçmayan.
- Gövde: sistem sans, normal ağırlık.

## Ürün / monetizasyon

- **2026-08-14 karar: tamamen ücretsiz.** Somna+ / paywall kavramı tamamen
  kaldırıldı — hiçbir özellik kilitli değil. Önceki "koç ücretsiz, hacim
  ücretli" planı terk edildi.

## Kişiselleştirme

- Onboarding'de doğum tarihi, boy, kilo, cinsiyet sorulur.
- Uyku hedefi, National Sleep Foundation'ın 2015 uzman panel raporundaki
  yaş bazlı süre aralıklarından hesaplanır (`SleepGoalCalculator`) — sabit
  8 saat değil, kişiye özel.
- Boy/kilo'dan BMI hesaplanır, sadece bağlamsal ve tıbbi olmayan bir not
  için kullanılır (ör. yüksek BMI → apne riski uyarısı) — süre hesabını
  etkilemez, çünkü bilimsel literatür süreyi yaşa bağlıyor, kiloya değil.

## Ekranlar

1. Onboarding (3 adım: karşılama, profil, kişisel hedef sonucu)
2. Bu gece (streak alevi + haftalık gün çemberleri — PushClock'un S M T W T F S
   satırı, skor kartı, süre/verimlilik kartları, uykuya dal/uyandım akışı)
3. İstatistik (gün: son gece evre dağılımı; hafta/ay: Swift Charts ile
   ortalama uyku süresi bar grafiği)
4. Uyandırma görevi (alarm kurulumundan açılan sheet — kamera viewfinder,
   nesne eşleştirme, geri sayım, + yatma vakti hatırlatıcısı)
5. Sesler (kategorilere ayrılmış geniş ses kütüphanesi — yağmur/fırtına,
   doğa, beyaz/pembe gürültü, enstrümantal, şehir/mekan)
6. Koç (sohbet + gömülü veri kartı)
7. Ayarlar (profil düzenleme, Gizlilik/Kullanım Şartları/Sağlık Bilgisi
   Açıklaması)

## Sonraki adımlar

- Gerçek Apple Health / HealthKit okuma entegrasyonu (şu an sadece rozet)
- Gerçek kamera + Vision framework ile nesne eşleştirme (şu an mockup)
- Gerçek sensör (hareket/ses) tabanlı uyku evresi tespiti — şu an placeholder
  heuristic (`SleepSession.estimatingStages`)
- **watchOS companion target** — rakiplerin çoğu (AutoSleep, SleepWatch,
  Sleep Cycle) Watch'ta otomatik tracking + complication sunuyor; bu ayrı
  bir Xcode target + entitlement gerektiren büyük bir sonraki milestone,
  bu turda kapsam dışı bırakıldı.
- "Programlar" (yapılandırılmış uyku iyileştirme müfredatı, RISE/BetterSleep
  tarzı) — kapsam dışı bırakıldı, ayrı bir özellik olarak planlanmalı.
- Uygulama ikonu ve gerçek marka kimliği — [[feedback_design_is_users_job]]
  gereği kullanıcı yapacak.
