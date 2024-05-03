<div>
  <h1 align="center">Nutrimatch Mobile</h1>
  <h3>Skills showcase project using AI to get recommendations based on photos or pictures of food</h3>
</div>

<div align="center">
  <a href="https://github.com/Dylan-Chambi/nutrimatch-mobile/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/badge/license-AGPLv3-purple"></a>
</div>

<br/>

Nutrimatch is a personal project that uses AI to get recommendations based on photos or pictures of food. This project is a showcase of skills and is not intended to be used in production, but rather to show my skills in the field of AI and mobile development.

## Features 🚀

- **Google Auth Provider:** Sign in with your Google account
- **Backend API connection:** Connect to the backend API to get recommendations
- **Camera and gallery usage:** Take a picture or select one from the gallery
- **Advanced Flutter concepts:** Utilization of Streams, Providers, Pull to refresh, tree flow, etc.
- **AI integration:** Utilization of AI for food recommendations based on images. Repository [Nutrimatch Backend](https://github.com/Dylan-Chambi/nutrimatch-backend)

## Demo 📱

<p align="center">
<img src="./assets/nutrimatch_demo.gif" alt="Nutrimatch Demo GIF">
</p>

## Tech Stack 💻

- [Flutter](https://flutter.dev/) – Framework
- [Dart](https://dart.dev/) – Language
- [Firebase](https://firebase.google.com/) – Authentication
- [Google Auth Provider](https://pub.dev/packages/google_sign_in) – Google Auth Provider
- [Http](https://pub.dev/packages/http) – HTTP requests

## Getting Started 🏁

### Prerequisites ✔️

Here's what you need to get started with this project:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Emulator or physical device (Android 7.0 or higher)
- iOS Simulator or physical device (iOS 10.0 or higher). NOT TESTED
- Recommended: [VSCode](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) with Flutter and Dart plugins
- [Firebase](https://firebase.google.com/) account and project
- [Flutterfire CLI](https://firebase.flutter.dev/docs/overview/)

### Installation Steps 🛠️

#### **1. Clone the repository**

```shell
git clone https://github.com/Dylan-Chambi/nutrimatch-mobile.git
cd nutrimatch-mobile
```

#### **2. Install pub dependencies**

```shell
flutter pub get
```

#### **3. Create a Firebase project**

> If you don't have a Firebase project, follow these steps to create one:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Sign in with your Google account.
3. Click on "Add project".
4. Follow the steps to create a new project.

> [Learn More](https://firebase.google.com/docs/projects/learn-more)

#### **4. Install Firebase CLI**

```shell
npm install -g firebase-tools
```

> Or you can follow the [FIrebase CLI installation](https://firebase.google.com/docs/cli#install_the_firebase_cli)

#### **5. Login to Firebase CLI**

**Note:** You need to login to Firebase CLI to configure Firebase for your project.

```shell
firebase login
```

#### **6. Install flutterfire CLI**

```shell
flutter pub global activate flutterfire_cli
```

> [Flutterfire CLI installation](https://firebase.flutter.dev/docs/cli#installation)

#### **7. Configure Firebase**

```shell
flutterfire configure
```

> Follow the steps to configure Firebase for your project.
> [More info](https://firebase.flutter.dev/docs/cli#usage)

#### **8. Run the app**

```shell
flutter run
```

## Project Structure 📂

```
lib
├───main.dart
├───api
├───assets
│   └───images
├───components
├───models
├───screens
├───services
├───theme
├───tree
└───utils
```

## License 📝

This project is licensed under the AGPLv3 License - see the [LICENSE](LICENSE) file for details.

## Author 👨‍💻

<p align="center">
  <a href="https://github.com/Dylan-Chambi">
  <img src="https://contrib.rocks/image?repo=Dylan-Chambi/nutrimatch-mobile"/>
  <p align="center">Dylan Chambi</p>
  </a>
</p>
