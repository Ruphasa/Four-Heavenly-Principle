# Normalized Database Design

This app currently uses Firebase Firestore (NoSQL), which favors denormalization. However, here is a normalized relational design and how to represent it in Firestore using document references and subcollections.

## Relational Schema (3NF)

Entities and relationships:

- Users (`users`)
  - id (PK)
  - name, email, phone, role

- Channels (`channels`)
  - id (PK)
  - name, description
  - created_by (FK -> users.id)

- BroadcastMessages (`broadcast_messages`)
  - id (PK)
  - channel_id (FK -> channels.id)
  - sender_id (FK -> users.id)
  - title, body, sent_at

- Activities (`activities`)
  - id (PK)
  - title, description, category, date, status
  - organizer_id (FK -> users.id)

- ActivityLogs (`activity_logs`)
  - id (PK)
  - activity_id (FK -> activities.id)
  - user_id (FK -> users.id)
  - action, timestamp

- Transactions (`transactions`)
  - id (PK)
  - amount, type, date
  - created_by (FK -> users.id)

- Citizens (`citizens`)
  - id (PK)
  - name, nik, gender, email
  - house_id (FK -> houses.id)
  - family_id (FK -> families.id)

- Families (`families`)
  - id (PK)
  - card_number, address
  - head_citizen_id (FK -> citizens.id)

- Houses (`houses`)
  - id (PK)
  - address, rt, rw

- FamilyMutations (`family_mutations`)
  - id (PK)
  - family_id (FK -> families.id)
  - type, date, notes

- PenerimaanWarga (`penerimaan_warga`)
  - id (PK)
  - applicant_citizen_id (FK -> citizens.id) [optional if not yet a citizen]
  - name, nik, gender, email, status, identity_photo_url

- PesanWarga (`pesan`)
  - id (PK)
  - citizen_id (FK -> citizens.id)
  - title, body, sent_at

## Firestore Representation

Firestore does not enforce foreign keys, but we can maintain normalized relationships using:

- Store `id` references (string document IDs) in related documents, e.g., `activity.organizerId`, `broadcastMessage.channelId`, `broadcastMessage.senderId`.
- Use subcollections when relationship is tightly coupled:
  - `activities/{activityId}/logs` (instead of separate collection), but current separate `activity_logs` is fine.
- Maintain consistency via code: when deleting a parent, cascade delete related children.

### Collections and Fields (proposed)

- `users`
  - `name`, `email`, `phone`, `role`

- `channels`
  - `name`, `description`, `createdByUserId`

- `broadcast_messages`
  - `channelId`, `senderUserId`, `title`, `body`, `sentAt`

- `activities`
  - `title`, `description`, `category`, `date`, `status`, `organizerUserId`

- `activity_logs`
  - `activityId`, `userId`, `action`, `timestamp`

- `transactions`
  - `amount`, `type`, `date`, `createdByUserId`

- `families`
  - `cardNumber`, `address`, `headCitizenId`

- `houses`
  - `address`, `rt`, `rw`

- `citizens`
  - `name`, `nik`, `gender`, `email`, `houseId`, `familyId`

- `family_mutations`
  - `familyId`, `type`, `date`, `notes`

- `penerimaan_warga`
  - `name`, `nik`, `gender`, `email`, `statusRegistrasi`, `fotoIdentitas`, `applicantCitizenId`

- `pesan`
  - `citizenId`, `title`, `body`, `sentAt`

## Implementation Guidelines

- Update models to include related document IDs (e.g., `organizerUserId`, `channelId`).
- Repositories: ensure `toJson`/`fromJson` read/write these IDs.
- UI pages: resolve references by fetching related docs or using `StreamProvider.family`.
- Seeders: generate coherent data with valid relations (e.g., users -> channels -> broadcasts).
- Deletions: implement manual cascade or prevent deletion when children exist.

## Next Steps

1. Add relation fields to models where missing.
2. Update repositories and providers to handle lookups.
3. Adjust seed data to produce normalized relationships.
4. Incrementally refactor pages to load related entities.
