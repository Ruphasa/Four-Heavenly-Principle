# Providers (Riverpod)

Tempatkan semua deklarasi Riverpod provider di folder ini, misalnya:

- StateProvider / StateNotifierProvider untuk state UI
- FutureProvider / StreamProvider untuk operasi async (API, Firebase, dsb.)
- Provider untuk dependency injection (service, repository)

Struktur yang disarankan:

```
lib/
  providers/
    app_providers.dart         # provider global (theme, router, dsb.)
    auth_providers.dart        # provider terkait autentikasi
    dashboard_providers.dart   # provider statistik/dashboard
    keuangan_providers.dart    # provider fitur keuangan
    ...
```

Contoh:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Contoh state sederhana
final counterProvider = StateProvider<int>((ref) => 0);

// Contoh provider service
// final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Contoh FutureProvider
// final usersProvider = FutureProvider<List<User>>((ref) async {
//   final api = ref.read(apiServiceProvider);
//   return api.fetchUsers();
// });
```

Tips:
- Akses provider di widget dengan `ref.watch(...)` atau `ref.read(...)` (ConsumerWidget/Consumer).
- Kelompokkan provider per fitur agar mudah dirawat.
- Re-export provider di satu berkas `app_providers.dart` bila ingin impor tunggal.
