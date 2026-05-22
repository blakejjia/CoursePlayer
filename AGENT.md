# Course Player (Lemon🍋‍) Project Review

This file documents the findings, anomalies, inconsistencies, and recommended refactoring opportunities discovered during the initial review of the codebase.

---

## 1. Project Overview & Architecture

- **Core Framework**: Flutter (Dart SDK version `^3.5.3`)
- **App Name/Branding**:
  - `pubspec.yaml` lists the name as `lemon` and description as `Lemon🍋‍ - offline music player`.
  - The UI (e.g., `AlbumPage` title) displays `Courser`.
  - Settings page uses `Courses` as the navigation destination label.
- **State Management**: Riverpod (`flutter_riverpod`, `hooks_riverpod`, `riverpod_annotation`). Most providers use the legacy `StateNotifier` approach.
- **Navigation**: `go_router` (`^17.2.3`).
- **Audio Core**: `just_audio` paired with `audio_service` for background audio capabilities.
- **Persistence**: Flat-file JSON structure (`MediaLibrary.json`) loaded via `MediaLibraryStore` with atomic file-writing. UI state/settings are persisted using `shared_preferences`.
- **AI Features**: Gemini API via `google_generative_ai` for sorting course folders and cleaning titles intelligently.

---

## 2. Inconsistencies & Issues Discovered

### A. Typos & Spelling Mistakes
1. **Misspelled Directory**: `lib/core/audio/providers/porgress` contains `progress_update_provider.dart`. It should be renamed to `progress`.
2. **Settings Menu Typo**: In `lib/features/settings/presentation/setting_page.dart` (line 31), the title is `"select dictionary"`. This should be `"select directory"`.

### B. Unused Services & Files
1. **Unused API Service**: `lib/features/playList/services/playlist_api_service.dart` defines `PlaylistApiService` and `playlistApiServiceProvider`, but it is not imported or used anywhere else. Is it a leftover or intended for cloud-syncing?
2. **Missing App Lifecycle Service**: `dev-doc/PROGRESS_SAVING_SYSTEM.md` references a `core/services/app_lifecycle_service.dart` that does not exist in the codebase. However, app lifecycle callbacks are already implemented directly inside `AudioPlayerNotifier` in `audio_player_provider.dart`.

### C. Potential Null-Check Crash
In `lib/features/playList/songs_list_page.dart` (lines 73-77):
```dart
OutlinedButton(
  onPressed: () {
    ref.read(songListProvider.notifier).playSong(
          album.lastPlayedSong!,
        );
  },
```
- **The Issue**: If the album has no `lastPlayedSong` (i.e. the user has not started listening to any song in it yet), calling `album.lastPlayedSong!` will throw a Null Check crash.
- **The Fix**: We should safely default to the first song in the album:
  ```dart
  final songToPlay = album.lastPlayedSong ?? album.songs.firstOrNull;
  if (songToPlay != null) {
    ref.read(songListProvider.notifier).playSong(songToPlay);
  }
```

### D. Mixed Localization
- Parts of the UI use English (e.g. `"settings"`, `"theme color"`, `"rebuild index"`).
- Other parts, especially playlist/AI-sort dialogs, are hardcoded in Chinese (e.g. `"播放列表设置"`, `"按文件创建时间"`, `"获取 AI 排序分析"`, `"AI 正在分析中..."`).
- We should standardize these or use the JSON assets (`assets/lang/...`) properly.

---

## 3. Recommended Refactoring Tasks

We can execute the following refactoring steps:

1. **Rename misspelled directory**: Rename `/porgress` to `/progress` and fix any imports.
2. **Fix Settings UI typos**: Change `"select dictionary"` to `"select directory"`.
3. **Fix the Null-Check Crash**: Safeguard `SongsListPage`'s resume button.
4. **Upgrade to Riverpod 2.x `@riverpod` annotations**:
   - Modernize the providers (e.g. `SettingsNotifier`, `AudioPlayerNotifier`, `AlbumsNotifier`) by generating them using `@riverpod` annotation.
   - This ensures type safety and adheres to current Riverpod best practices.
5. **Clean up unused files/code**:
   - Confirm if we can remove or placeholder `playlist_api_service.dart`.
6. **Dynamic cover loading**:
   - Implement dynamic cover loading (e.g. reading embedded tags using `audiotags` or finding `.jpg`/`.png` files in the course folder).
