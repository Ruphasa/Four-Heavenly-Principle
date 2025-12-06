# Firebase Cloud Messaging (FCM) Setup

## Overview
Aplikasi ini menggunakan Firebase Cloud Messaging (FCM) untuk mengirim notifikasi push ke pengguna saat ada pesan baru.

## Setup Android

### 1. Update AndroidManifest.xml

Tambahkan permission dan service di `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
    
    <application>
        <!-- ... existing config ... -->
        
        <!-- FCM Service -->
        <service
            android:name="com.google.firebase.messaging.FirebaseMessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
        
        <!-- FCM default notification channel -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="pesan_channel" />
    </application>
</manifest>
```

### 2. Update build.gradle

Pastikan sudah ada Google services di `android/app/build.gradle`:

```gradle
plugins {
    id 'com.android.application'
    id 'com.google.gms.google-services'
}
```

## Setup iOS

### 1. Enable Push Notifications

1. Buka Xcode project: `open ios/Runner.xcworkspace`
2. Pilih target "Runner"
3. Buka tab "Signing & Capabilities"
4. Klik "+ Capability" dan tambahkan "Push Notifications"
5. Tambahkan juga "Background Modes" dan centang "Remote notifications"

### 2. Update Info.plist

Tidak ada perubahan tambahan yang diperlukan untuk FCM.

## Firebase Console Setup

### 1. Enable Cloud Messaging

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Buka "Cloud Messaging" dari menu sebelah kiri
4. Enable Cloud Messaging API jika belum aktif

### 2. Upload APNs Certificate (iOS Only)

1. Di Firebase Console, buka "Project Settings"
2. Pilih tab "Cloud Messaging"
3. Scroll ke bagian "Apple app configuration"
4. Upload APNs Authentication Key atau Certificate

## Testing FCM

### Manual Test dari Firebase Console

1. Buka Firebase Console > Cloud Messaging
2. Klik "Send your first message"
3. Masukkan notifikasi title dan text
4. Pilih target (app, topic, atau token)
5. Klik "Send test message"

### Test dengan Firebase CLI

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Test notification
firebase messaging:send --to "DEVICE_TOKEN" --notification-title "Test" --notification-body "Hello from FCM"
```

## Cloud Function (Optional)

Untuk mengirim notifikasi otomatis saat ada pesan baru, deploy Cloud Function:

```javascript
// functions/index.js
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendPesanNotification = functions.firestore
  .document('notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notification = snap.data();
    
    if (notification.processed) return null;
    
    const message = {
      notification: {
        title: notification.title,
        body: notification.body,
      },
      data: notification.data,
    };
    
    try {
      if (notification.token) {
        // Send to specific device
        await admin.messaging().send({
          ...message,
          token: notification.token,
        });
      } else if (notification.topic) {
        // Send to topic
        await admin.messaging().send({
          ...message,
          topic: notification.topic,
        });
      }
      
      // Mark as processed
      await snap.ref.update({ processed: true });
      
      console.log('Notification sent successfully');
    } catch (error) {
      console.error('Error sending notification:', error);
      await snap.ref.update({ 
        processed: true, 
        error: error.message 
      });
    }
    
    return null;
  });
```

Deploy dengan:

```bash
cd functions
npm install
firebase deploy --only functions
```

## Troubleshooting

### Android: Notifications not showing

1. Pastikan Google Play Services terinstall
2. Cek permission notifikasi di Settings > Apps > Pentagram
3. Pastikan notification channel sudah dibuat

### iOS: Notifications not showing

1. Pastikan APNs certificate sudah diupload
2. Cek permission notifikasi di Settings > Pentagram
3. Test di device fisik (simulator tidak support push notifications)

### Token tidak didapat

1. Pastikan Firebase sudah diinisialisasi
2. Cek permission di device settings
3. Restart aplikasi

## Production Checklist

- [ ] Upload production APNs certificate (iOS)
- [ ] Enable Cloud Messaging API di Google Cloud Console
- [ ] Deploy Cloud Function untuk otomatis kirim notifikasi
- [ ] Setup notification icons dan channels
- [ ] Test notifikasi di production environment
- [ ] Monitor FCM analytics di Firebase Console
