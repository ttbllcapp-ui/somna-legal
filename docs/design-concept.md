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
2. Bu gece (skor halkası, Health/Watch rozetleri, süre/verimlilik kartları,
   uykuya dal/uyandım akışı)
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
