# Docu Fetch

Docu Fetch is a mobile application that fetches PDF from a server, import it in the app and and allows you to read it in a nice PDF viewer.

## Getting Started

- Clone the project
- Run `flutter pub get`

## How to use Docu Fetch

### Server side setup

- Put every PDF files you want to fetch in an open folder of your server
- You can put a .json file in the same folder with the same name as the PDF file to add a title and a description to the PDF
    - Example :
  ```
  { "pdfs": [
    {
      "title": "My PDF Title 1",
      "description": "My PDF Description 1"
      "path": "my_pdf_1.pdf"
    },
    {
      "title": "My PDF Title 2",
      "description": "My PDF Description 2"
      "path": "my_pdf_2.pdf"
    },
    ...
    ]
  }
  ```

### Client side

- In the Home page, select the icon "Add PDF"
- In the field you just have to add the url (repo) where your pdf files are stored
- Click on "Add" and the app will fetch the PDF files and display them in the Home page


## Included Functionalities

- Clean Architecture
- GetX : State management and reactivity
- Dio : Http client
- Localized string powered by GetX
- Light Mode / Dark Mode (Custom Theme implementation)
- PDFView customized


### Localization

- Add localized string in /lib/util/localization/app_translation.dart
- Easiest localization system powered by GetX : https://pub.dev/packages/get#internationalization
