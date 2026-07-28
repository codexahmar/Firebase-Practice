# Flutter Firebase Master Practice 🚀

A comprehensive, beginner-friendly Flutter project demonstrating the integration of various Firebase services. This repository serves as a complete reference for implementing Authentication, Realtime Database, and Cloud Firestore with a clean, modern UI.

## ✨ Features

### 🔐 Firebase Authentication
- **Email/Password**: Sign up, Login, and Password Reset.
- **Phone Authentication**: OTP-based login with phone number verification.
- **Robust Error Handling**: User-friendly error messages mapped from Firebase exception codes.
- **Session Management**: Persistent login states with a dedicated Splash Service.

### 📊 Firebase Realtime Database
- **CRUD Operations**: Create, Read, Update, and Delete posts in real-time.
- **Live Search**: Efficiently filter realtime data as you type.
- **Animated Lists**: Smooth UI transitions using `FirebaseAnimatedList`.

### ☁️ Cloud Firestore
- **Document Management**: Modern way to store and sync data.
- **Real-time Streams**: Instant UI updates using Firestore snapshots.
- **Search Functionality**: Client-side filtering for Firestore documents.

## 📂 Project Structure

```text
lib/
├── main.dart                # App entry point & global theme configuration
├── services/                # Business logic & Firebase API wrappers
│   ├── auth_service.dart      # All Authentication logic
│   ├── realtime_db.dart       # Realtime Database operations
│   ├── firestore_service.dart # Cloud Firestore operations
│   └── splash_service.dart    # Logic for routing on app start
├── ui/                      # Presentation layer (UI Screens)
│   ├── auth/                  # Auth related screens (Login, Signup, OTP)
│   ├── firestore/             # Cloud Firestore CRUD screens
│   ├── home_screen.dart       # Realtime Database Dashboard
│   ├── post_screen.dart       # Add data to Realtime Database
│   └── splash_screen.dart     # Initial loading screen
├── widgets/                 # Reusable UI components
│   ├── custom_text_field.dart # Standardized input fields
│   └── round_button.dart      # Primary action buttons with loading states
└── utils/                   # Helper classes
    └── utils.dart             # Global utility for Toasts/Snackbars
```

## 🎨 UI/UX Highlights
- **Sleek Dark Theme**: Professional black and white aesthetic.
- **Consistent Design**: Reusable widgets ensure a uniform look and feel.
- **Responsive**: Clean layouts that prevent overflow and handle different screen sizes.
- **UX feedback**: Integrated loading indicators and toast notifications for every action.

## 🚀 Getting Started

1. **Prerequisites**:
   - Flutter SDK installed.
   - A Firebase project created in the [Firebase Console](https://console.firebase.google.com/).

2. **Firebase Setup**:
   - Add your Android/iOS app to the Firebase project.
   - Download and place `google-services.json` in `android/app/`.
   - Enable **Email/Password** and **Phone** providers in Firebase Auth.
   - Create a **Realtime Database** and **Cloud Firestore** instance.

3. **Run the App**:
   ```bash
   flutter pub get
   flutter run
   ```

## 🤝 Contributing
This project is designed for beginners. Feel free to fork, open issues, or submit pull requests to improve the learning experience!

---
*Built with ❤️ for the Flutter Community.*
