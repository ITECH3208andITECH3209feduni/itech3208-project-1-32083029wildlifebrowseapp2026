# Browse Wildlife App

Hey Wildlife team!

Browse Wildlife App is a Flutter-based mobile application developed for ITECH3208/ITECH3209. The application connects Caretakers, Gatherers, and Landholders to help manage wildlife browse requests, browse collection, and property listings through one platform.

---

# Project Features

- Role-based login and navigation
- New user onboarding and tutorial system
- Manual onboarding access for returning users
- Browse request creation and management
- Accept → Finish → Completed request workflow
- Landholder browse listing management
- Searchable browse catalogue and plant identification
- Help & FAQ support screen
- Standalone Node.js + MongoDB backend
- AWS Cognito authentication and role management

---

# Project Structure

## The Files

### .dart_tool, build and .flutter-plugins
These files only appear during build time (when the project runs). Sometimes Flutter may fail to rebuild due to permission issues. If this occurs, these files/folders can be deleted manually.

---

### assets
Contains application assets such as:
- images
- onboarding videos
- browse catalogue thumbnails

---

### android and ios
Platform-specific build configurations for Android and iOS devices, including app permissions and launcher icons.

---

### backend
Contains the standalone Node.js and Express backend used by the application.

The backend:
- handles CRUD operations
- manages browse requests
- communicates with MongoDB Atlas
- processes request status updates

---

### lib
Contains the Dart files and frontend application logic.

Subdirectories are organised by user flow and functionality.

---

# Frontend Structure

### auth/
Contains all screens and logic related to:
- sign in
- sign up
- onboarding
- agreement flow
- authentication routing

---

### caretaker-view/
Contains screens and logic related to:
- browse request creation
- request management
- caretaker dashboard

---

### gatherer-view/
Contains screens and logic related to:
- request board
- request acceptance
- request completion workflow

---

### landholder-view/
Contains screens and logic related to:
- landholder registration
- property listings
- browse availability management

---

### education/
Contains screens and logic related to:
- browse catalogue
- plant identification
- browse searching
- educational browse information

Future versions may include harvesting tutorials and advanced browse guidance.

---

### models/
Contains model classes used to convert JSON data from the backend into Flutter objects.

---

### personal/
Contains screens related to:
- user profile
- personal account details

---

### templates/
Contains reusable widgets and shared UI components used throughout the app.

Examples include:
- drawer widgets
- browse listing panels
- reusable cards and layouts

---

### jsonParser.dart
Contains logic for converting JSON objects to Flutter objects and vice versa.

---

### main.dart
The main entry point of the application.

Contains:
- route definitions
- navigation configuration
- onboarding flow logic

---

### web
Contains web configuration files used for Chrome testing.

---

### pubspec.yaml
Contains Flutter package dependencies and project configuration.

Packages can be installed using:

```bash
flutter pub add <package_name>
```

---

# Backend & Authentication

## MongoDB Atlas
MongoDB Atlas is used as the cloud database for storing:
- requests
- listings
- browse data
- user-related information

---

## AWS Cognito
AWS Cognito handles:
- user authentication
- sign up/sign in
- role-based access control

Supported roles:
- Caretaker
- Gatherer
- Landholder

---

# User Roles

## Caretaker
Caretakers can:
- create browse requests
- edit requests
- delete requests
- monitor request progress
- view completed request status

---

## Gatherer
Gatherers can:
- view browse requests
- accept requests
- complete requests using the Finish button
- access browse information and onboarding tutorials

---

## Landholder
Landholders can:
- create property listings
- manage browse availability
- edit listings
- delete listings

---

# Request Workflow

The application uses the following request lifecycle:

```text
Pending → Accepted → Finished
```

Workflow:
- Caretakers create browse requests
- Gatherers accept requests
- Assigned Gatherers complete requests using the Finish button
- Caretakers can monitor request completion status

---

# Onboarding System

The onboarding system includes:
- agreement screen
- instructional content
- onboarding videos
- role-based onboarding access

Features:
- New users complete onboarding after registration
- Returning users bypass onboarding automatically
- Returning users can manually reopen onboarding from the app drawer

---

# Setup Instructions

## 1. Clone the repository

```bash
git clone https://github.com/ITECH3208andITECH3209feduni/itech3208-project-1-32083029wildlifebrowseapp2026.git
```

---

## 2. Navigate to the project folder

```bash
cd itech3208-project-1-32083029wildlifebrowseapp2026
```

---

## 3. Install Flutter dependencies

```bash
flutter pub get
```

---

## 4. Set up backend dependencies

```bash
cd backend
npm install
```

---

## 5. Configure environment variables

Create a `.env` file inside the backend folder:

```env
MONGO_URI=your_mongodb_connection_string
PORT=5000
```

---

## 6. Start backend server

```bash
npm start
```

or

```bash
node server.js
```

---

## 7. Run the Flutter application

Open a new terminal and run:

```bash
flutter run
```

The app can be tested using:
- Android Emulator
- iOS Simulator
- Chrome Browser

---

# Backend API Endpoints

## Request APIs

```text
GET    /requestsAPI
POST   /requestsAPI
PATCH  /requestsAPI/:request_ID/:status_Num
DELETE /requestsAPI/:request_ID/:status_Num
```

---

## Landholder APIs

```text
GET    /landholders
POST   /landholders
```

---

# Technology Stack

## Frontend
- Flutter
- Dart

## Backend
- Node.js
- Express.js

## Database
- MongoDB Atlas

## Authentication
- AWS Cognito

## Version Control
- Git
- GitHub

---

# Current Project Status

Sprint 2 features are fully functional and ready for showcase/demo.

Completed features include:
- onboarding improvements
- standalone backend migration
- request lifecycle workflow
- role-based navigation
- browse catalogue
- CRUD operations
- request completion status handling
- improved user experience