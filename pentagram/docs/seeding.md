# Firestore Seeding (Normalized)

This project includes a simple seeder to populate normalized, linked demo data for local/dev testing.

Collections seeded:
- users
- channels (createdByUserId → users)
- families (headCitizenId set after citizens are created)
- houses
- citizens (familyId → families, houseId → houses)
- activities (organizerUserId → users)
- activity_logs (activityId → activities, userId → users)
- broadcast_messages (channelId → channels, senderUserId → users)
- transactions (createdByUserId → users)
- penerimaan_warga (applicantCitizenId → citizens)
- pesan (citizenId → citizens)

## How to run (in-app)
Temporarily invoke the seeder from your app in a dev-only code path:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pentagram/seeders/seeders.dart';

Future<void> seedNow() async {
  final fs = FirebaseFirestore.instance;
  final seed = Seeders(fs);
  await seed.runAll(clearBefore: true); // clears then reseeds
}
```

Call `seedNow()` from a debug button or an init block guarded by `kDebugMode`.

To reseed, run again with `clearBefore: true` after emptying your database or let the seeder clear known collections for you.
