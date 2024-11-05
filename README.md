# Patient Vital Recorder

A Flutter-based mobile application for healthcare providers to record and manage patients' vital signs. This app allows data entry both manually and through capturing images of devices to extract and record vital information using Google Vision API for text extraction.

## Features

- **Manual Input**: Allows healthcare providers to manually input patients' vital signs such as heart rate, blood pressure, temperature, and more.
- **Image-Based Extraction**: Captures images of medical devices (e.g., monitors, thermometers) to automatically read and record vitals using OCR (Optical Character Recognition) provided by Google Vision API.
- **Google Vision API Integration**: Utilizes Google Vision API for efficient text extraction from images, allowing easy and accurate data entry from device displays.
- **Data Management**: Stores recorded vitals for each patient, providing easy access and review for future reference.

## Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **APIs**: Google Vision API for OCR

## Setup

### Prerequisites

1. **Flutter**: Install Flutter from [Flutter’s official website](https://flutter.dev/docs/get-started/install).
2. **Google Cloud Account**: Set up a Google Cloud account to access the Google Vision API.

### Step-by-Step Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/haseeb475/ANTIC.git
   cd ANTIC
   ```

2. **Install Dependencies**:
   Install Flutter dependencies by running:
   ```bash
   flutter pub get
   ```

3. **Google Vision API Setup**:
   - Go to the [Google Cloud Console](https://console.cloud.google.com/).
   - Create a new project or select an existing one.
   - Enable the Google Vision API.
   - Create and download a service account key in JSON format.
   - Place the JSON file in your project directory and rename it if needed, e.g., `google_vision_key.json`.

4. **Environment Configuration**:
   - Set up the environment variable for the Google Vision API key path.
   - In your Flutter project, configure access to the Vision API in your code, using the path to the service account JSON key.

### Run the App

To run the app on an emulator or physical device, execute:

```bash
flutter run
```

## Usage

1. **Manual Entry**:
   - Select a patient from the list or add a new patient.
   - Manually input vitals such as heart rate, blood pressure, temperature, etc.

2. **Capture Image**:
   - Choose the option to capture an image of the device showing the patient’s vitals.
   - The app will process the image using the Google Vision API and automatically extract and record the text.

3. **View Records**:
   - All recorded vitals for each patient are saved and accessible in the app, providing a historical view for healthcare providers.

## Project Structure

- **lib/**: Contains the main Flutter application code.
  - **models/**: Data models for patient information and vitals.
  - **screens/**: Screens for manual entry, camera capture, and records display.
  - **services/**: Contains the API service to interact with Google Vision API.
  - **widgets/**: Custom widgets for various components, such as data entry fields and image capture.

## Dependencies

- **google_ml_vision**: Used for integrating with Google Vision API for OCR.
- **camera**: Flutter package for capturing images.
- **provider**: State management for managing app-wide states, such as patient data.
- **flutter/material.dart**: Flutter’s core UI toolkit.
