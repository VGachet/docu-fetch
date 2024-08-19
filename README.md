# Docu Fetch

DocuFetch is a mobile application that fetches PDF files from a server, import it in the app and allows you to read it in a nice PDF viewer.

## Getting Started

- Clone the project
- Run `flutter pub get`


## How to use Docu Fetch


### Server side setup

#### This is how you setup your own "DocuFetch repository":

- Put every PDF files you want to fetch in an open folder of your server
  - Create a .json file in the same folder with the following structure to describe the PDF files:
      - Example :
    ```
    { "pdfs": [
      {
        "title": "My PDF Title 1",
        "description": "My PDF Description 1"
        "path": "my_pdf_1.pdf",
        "version": 1.0
      },
      {
        "title": "My PDF Title 2",
        "description": "My PDF Description 2"
        "path": "my_pdf_2.pdf",
        "version": 1.2
      },
      ...
      ]
    }
    ```
    - The "path" field should point to the PDF file in the same folder
    - The "version" field is used to update the PDF file in the app if the version is different from the one in the app
    - The "title" and "description" fields are used to display the PDF in the app

### Client side (mobile app)

- In the Home page, select the "Menu" floating button
- To download PDF files from a server, click on "Add PDF from URL" then in the field, add a url that point to the json file of a DocuFetch repository
- To import a PDF file from your device, click on "Import PDF from device"
- To read a PDF file, click on the PDF file in the Home page
- To delete a PDF file, click on the "Delete" button in the PDF file page
- To update PDF files, select the "Menu" floating button in the PDF file page, choose "Your repository list" and click on the repository you want to update the PDF file from
