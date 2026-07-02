# Collab Tasker

A collaborative task management application built with Flutter and Firebase, designed for teams to create shared workspaces, manage tasks, and coordinate work in real time across mobile and desktop platforms.

---

## Overview

Collab Tasker is a cross-platform Flutter application that lets users organize team work through the concept of **workspaces** — isolated project spaces where members can create tasks, track progress, and invite collaborators. The backend is entirely powered by Firebase, providing real-time data sync, secure authentication, and push notifications out of the box.

The codebase follows a feature-first clean architecture pattern with a clear separation between domain, data, and presentation layers across each feature.

---

## Features

- **Workspace management** — Create, update, and delete workspaces. Each workspace tracks member count, total tasks, completed tasks, and an automatically computed completion percentage.
- **Task lifecycle** — Add tasks with a title and description, update their status (Pending → In Progress → Completed), and delete them. Task stats are recalculated in Firestore automatically on every change.
- **Member invitations** — Invite collaborators by email address. If the invitee already has an account, they receive a pending invite. If they do not, their email is stored as a pending member and they are added upon registration.
- **Member management** — Workspace creators can remove existing members and cancel pending invitations.
- **Role-based access** — Only the workspace creator can edit workspace details or delete the workspace. All operations are enforced at both the UI and Firestore security rules level.
- **Real-time updates** — Workspace details and task lists are bound to Firestore streams, so changes made by any member are reflected immediately without requiring a manual refresh.
- **Push notifications** 🔔 — Firebase Cloud Messaging handles remote push notifications. Foreground messages are surfaced as local notifications via `flutter_local_notifications`.
- **Paginated workspace list** — The workspace list screen loads workspaces in pages of 10, with automatic fetch-on-scroll for the next page.
- **Search bar** — A workspace search field is present on the list screen (UI is in place; filter logic is a planned addition).
- **Dark theme** — The app ships with a single carefully crafted dark theme. There is no light theme.
- **Responsive layout** — All dimensions are adapted to screen size using `flutter_screenutil` with a design baseline of 393×852.

---

## Architecture

The project follows **feature-first clean architecture**. Each feature owns its domain, data, and presentation layers internally, and shared infrastructure lives in `core/`.

```
lib/
├── config/
│   └── app_router.dart          # GoRouter configuration and named routes
├── core/
│   ├── services/
│   │   └── notification_service.dart   # FCM setup, local notification display
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── utils/
│       └── app_snackbar.dart
├── features/
│   ├── auth/
│   │   ├── data/repositories/   # Firebase Auth calls, UID lookup by email
│   │   ├── domain/repositories/ # Auth repository interface
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── pages/           # SignInScreen, SignUpScreen
│   │       └── widgets/         # AuthBackground (shared gradient background)
│   ├── splash/
│   │   └── presentation/pages/  # SplashScreen (auth state redirect)
│   └── workspace/
│       ├── data/
│       │   ├── models/          # WorkspaceModel, WorkspaceTaskModel (Firestore ↔ entity)
│       │   └── repositories/    # WorkspaceRepositoryImpl
│       ├── domain/
│       │   ├── entities/        # Workspace, WorkspaceTask (TaskPriority, TaskStatus enums)
│       │   └── repositories/    # WorkspaceRepository interface
│       └── presentation/
│           ├── controllers/     # AddWorkspaceController, WorkspaceListController,
│           │                    # WorkspaceDetailController
│           ├── pages/           # WorkspaceListScreen, AddWorkspaceScreen,
│           │                    # WorkspaceDetailScreen
│           └── widgets/
│               ├── workspace_card.dart
│               └── detail/      # WorkspaceTaskList, WorkspaceMemberList,
│                                # WorkspaceDialog
├── widgets/
│   ├── app_button.dart          # Primary CTA button with loading state
│   ├── app_textfield.dart       # Labelled input field with prefix icon
│   └── glass_container.dart     # Frosted-glass container used throughout
├── firebase_options.dart
└── main.dart
```

**State management**: GetX is used as a service locator and reactive state layer (`Rx<T>`, `Obx`). Controllers are injected with `Get.put()` and tagged by workspace ID where multiple instances can coexist.

**Navigation**: GoRouter handles all routing. The router is configured with a `navigatorKey` and routes are defined as named constants in `AppRoutes`. The workspace detail route passes a `Workspace` entity via `extra`.

---

## Technology Stack

| Category | Package | Version |
|---|---|---|
| Framework | Flutter | ≥ 3.8.1 |
| Language | Dart SDK | ^ 3.8.1 |
| Auth | firebase_auth | ^ 5.4.1 |
| Database | cloud_firestore | ^ 5.6.2 |
| Push notifications | firebase_messaging | ^ 15.2.10 |
| Local notifications | flutter_local_notifications | ^ 17.2.3 |
| State / DI | get | ^ 4.6.6 |
| Navigation | go_router | ^ 14.3.0 |
| Responsive layout | flutter_screenutil | ^ 5.9.3 |
| UI effects | glassmorphism | ^ 3.0.0 |
| Typography | google_fonts | ^ 6.2.1 |
| Image caching | cached_network_image | ^ 3.4.1 |
| SVG rendering | flutter_svg | ^ 2.0.10 |
| Shimmer loading | shimmer | ^ 3.0.0 |
| Icons | cupertino_icons | ^ 1.0.8 |

---

## Firestore Data Model

### `workspaces/{workspaceId}`

| Field | Type | Notes |
|---|---|---|
| `name` | string | |
| `description` | string | |
| `createdBy` | string | UID of the creator |
| `members` | array\<string\> | UIDs of active members (includes creator) |
| `pendingInvites` | array\<string\> | UIDs of users who have been invited but not yet accepted |
| `pendingMembers` | array\<string\> | Email addresses invited before account creation |
| `createdAt` | timestamp | |
| `lastActivityAt` | timestamp | Updated on every task add/update |
| `totalTasks` | number | Auto-recalculated on task changes |
| `completedTasks` | number | Auto-recalculated on task changes |
| `progress` | number | `completedTasks / totalTasks`, range 0.0–1.0 |

### `workspaces/{workspaceId}/tasks/{taskId}`

| Field | Type | Notes |
|---|---|---|
| `title` | string | |
| `description` | string | |
| `status` | string | `pending` \| `inProgress` \| `completed` |
| `priority` | string | `low` \| `medium` \| `high` |
| `assignedTo` | string | UID of the user who created the task |
| `workspaceId` | string | Denormalized for convenience |
| `dueDate` | timestamp? | Optional |
| `createdAt` | timestamp | |

### `users/{userId}`

| Field | Type |
|---|---|
| `email` | string |
| `displayName` | string |
| `createdAt` | timestamp |

---

## Firestore Security Rules

Access is enforced at the database level:

- A user can read or write a workspace only if their UID is in the `members` array.
- A user can create a workspace only if their UID is in the new document's `members` array.
- Task access requires membership in the parent workspace (resolved with a `get()` call).
- Users can only read and write their own document in the `users` collection.

---

## Prerequisites

- Flutter SDK **3.8.1 or later** — [Install Flutter](https://docs.flutter.dev/get-started/install)
- A **Firebase project** with the following services enabled:
  - Authentication (Email/Password provider)
  - Cloud Firestore
  - Firebase Cloud Messaging
- Android Studio or Xcode (for mobile targets)
- For web/desktop targets, the standard Flutter desktop/web setup applies

---

## Getting Started

### 1. Clone the repository

```bash
git clone <repository-url>
cd collab_tasker
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

#### Android
Download `google-services.json` from the Firebase console and place it at `android/app/google-services.json`.

#### iOS
Download `GoogleService-Info.plist` from the Firebase console and add it to the Xcode project at `ios/Runner/GoogleService-Info.plist`.

#### Web / Desktop
Update `lib/firebase_options.dart` with platform-specific keys from your Firebase project settings. You can regenerate this file using the FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Run the application

```bash
# Default device
flutter run

# Specific platform
flutter run -d android
flutter run -d ios
flutter run -d chrome
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

---

## Building for Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

---

## Code Quality

```bash
# Static analysis
flutter analyze

# Format code
dart format lib/

# Check for outdated dependencies
flutter pub outdated
```

The project uses `flutter_lints` with the default recommended ruleset defined in `analysis_options.yaml`.

---

## Known Limitations

- The search bar on the workspace list screen has its UI in place but filtering is not yet wired to the controller.
- Profile, Task Analytics, Settings, Help & Support, and Privacy Policy menu items in the drawer are scaffolded but not yet implemented.
- Task assignment always defaults to the current user. Assigning tasks to other workspace members is not yet supported.
- FCM background message handling is initialized but deep-link navigation on notification tap is not implemented.

---

## Contributing

1. Fork the repository and create a feature branch (`git checkout -b feature/your-feature`)
2. Follow the [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
3. Run `dart format lib/` and `flutter analyze` before committing
4. Open a pull request with a clear description of what changed and why

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Version:** 1.0.0+1  
**Dart SDK:** ^3.8.1  
**Status:** Active Development
