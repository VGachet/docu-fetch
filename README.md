# Clean Architecture Getx Flutter Template

This is a Flutter template using **Clean Architecture**, **GetX** for state management and reactivity and **Retrofit** as the HTTP client.

This project is a starting point for building an **easy scalable Flutter application**.

I used the amazing **Coingecko API** as an example [Coingecko API Doc](https://www.coingecko.com/en/api)

With the help of **GitHub Copilot**, I was able to create this project in a few hours.


## Getting Started

- Clone the project
- Run `flutter pub get`
- Run `flutter pub run build_runner build --delete-conflicting-outputs`


## Included Functionalities

- Clean Architecture
- GetX : State management and reactivity
- Retrofit : Http client
- Localized string powered by GetX
- Infinite scroll pagination, a simple implementation
- Light Mode / Dark Mode (Custom Theme implementation)


### Localization

- Add localized string in /lib/util/localization/app_translation.dart
- Easiest localization system powered by GetX : https://pub.dev/packages/get#internationalization
