# Cloudinary Mobile Uploader

A Flutter app for uploading images to [Cloudinary](https://cloudinary.com/) straight from your phone snap a photo or pick from your gallery, tag it, and upload, with a queue that tracks progress, retries, and history.

## Features

- **Camera & gallery capture**: take a photo on the spot or select multiple images from your gallery.
- **Upload queue**: images upload concurrently (configurable limit) with live per-image progress, cancel, and retry.
- **Editable upload options**: set a destination folder, tags, and a public ID per image before it uploads (or before a retry).
- **Upload history**: a local, on-device log of everything you've uploaded, with the Cloudinary URL, dimensions, size, and a one-tap copy-link action.
- **Unsigned uploads only**: the app never asks for your Cloudinary API secret. It authenticates purely via cloud name + an [unsigned upload preset](https://cloudinary.com/documentation/upload_presets), so there's no sensitive credential embedded in the app binary.
- **Light & dark themes**: that follow your system setting.

## Tech stack

- [Flutter](https://flutter.dev/) / Dart
- [flutter_riverpod](https://riverpod.dev/) for state management
- [go_router](https://pub.dev/packages/go_router) for navigation
- [dio](https://pub.dev/packages/dio) for HTTP/multipart uploads
- [image_picker](https://pub.dev/packages/image_picker) for camera/gallery access
- [shared_preferences](https://pub.dev/packages/shared_preferences) for local config and history storage

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ^3.12.2 — see `pubspec.yaml`)
- A Cloudinary account (the [free tier](https://cloudinary.com/users/register/free) is enough)
- An **unsigned upload preset** on that account:
  1. Cloudinary Console → Settings → Upload → Upload presets → Add upload preset
  2. Set **Signing Mode** to `Unsigned`
  3. Save, and note the preset name and your account's cloud name

## Getting started

```bash
git clone https://github.com/RakshakSigdel/cloudinary-mobile-uploader.git
cd cloudinary-mobile-uploader
flutter pub get
```

Run on a connected device or emulator:

```bash
flutter run
```

On first launch you'll be sent to the **Setup** screen to enter your Cloudinary cloud name and upload preset. These are stored locally on-device (via `shared_preferences`) and can be changed later from the settings icon on the Upload screen.

### Optional: dev defaults

To skip typing your cloud name/preset on every fresh install during development, pass them at launch and they'll pre-fill the setup form:

```bash
flutter run --dart-define=DEV_CLOUD_NAME=your-cloud-name --dart-define=DEV_UPLOAD_PRESET=your-preset-name
```

## Project structure

The app follows a feature-first layout, with each feature split into `data` / `domain` / `presentation`:

```
lib/
├── core/                 # Shared config, error types, networking, storage, reusable widgets
├── features/
│   ├── cloudinary_config/  # Cloud name + upload preset setup
│   ├── image_upload/       # Camera/gallery capture, upload queue, per-image options
│   └── upload_history/     # Local upload history
├── routing/              # go_router route definitions
├── app.dart              # MaterialApp + theme
└── main.dart              # Entry point
```

## Running tests

```bash
flutter test
```

Static analysis:

```bash
flutter analyze
```

## Contributing

Contributions are welcome!

1. Fork the repo and create a branch off `main`.
2. Make your changes, following the existing project structure and the lint rules in `analysis_options.yaml`.
3. Run `flutter analyze` and `flutter test` before opening a PR.
4. Open a pull request describing what changed and why.

If you're planning a larger change, please open an issue first to discuss it.

## Known limitations

- Upload history is stored locally only — it isn't synced across devices and doesn't reflect changes made directly in your Cloudinary dashboard.
- Because the app only holds an unsigned upload preset (no API secret), it can't edit or delete assets that have already been uploaded to Cloudinary — only local, pre-upload metadata is editable.

## License

This project is licensed under the [MIT License](LICENSE).
