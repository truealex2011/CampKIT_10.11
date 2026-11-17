# CampusLife — Flutter

Рабочее приложение находится в этой папке. `../CampusLife.html` — только
самодостаточный образец дизайна, его не нужно собирать или редактировать
для изменения приложения. Интерфейс приложения реализован виджетами Dart
в `lib/`, без WebView и без встраивания HTML-образца.

## Запуск в Google Chrome

Нужен Flutter с Dart >=3.11.4 <4.0.0. Проверено окружение Flutter 3.41.6 / Dart 3.11.4.
Из папки `campuslife_app`:

```text
flutter pub get
flutter run -d chrome
```

На текущем компьютере SDK находится в `C:\Users\1\flutter`.
При отсутствии Flutter в PATH используйте `C:\Users\1\flutter\bin\flutter.bat`.

## Проверки и сборка

```text
flutter analyze
flutter test
flutter build web --no-web-resources-cdn
```

`test/entry_layout_test.dart` проверяет центрирование входа, прокрутку
регистрации, клавиатуру и отсутствие подписи. `test/screenshots_test.dart`
сохраняет снимки Flutter в `build/test_shots/`.

Для просмотра собранной версии: `node tool/serve_web.mjs 0`.
Сервер печатает фактический адрес и отправляет заголовки для локальной SQLite.
Это средство просмотра Flutter, не отдельный сайт.

## Что сохранять

- `web/index.html` — загрузчик Flutter, не HTML-прототип.
- `web/drift.worker.js` и `web/sqlite3.wasm` — база данных Flutter в браузере.
- `tool/` — вспомогательные средства сборки и проверки Flutter.
- `THIRD_PARTY_NOTICES.md` — лицензионное уведомление анимации океана.

Приложение работает в двух режимах. Без `CAMPUSLIFE_API_URL` оно использует
встроенную локальную БД Drift (офлайн-демо). С аргументом
`--dart-define=CAMPUSLIFE_API_URL=http://127.0.0.1:8080` авторизация, лента,
события, заявки, медиа, избранное, напоминания, билеты и QR-проход идут через
сервер из `../campuslife_server` — данные синхронизируются между устройствами.
Подробности и полная инструкция — в корневом `README.md`.

Сейчас в проекте настроена платформа web; для сборки Android/iOS понадобятся
соответствующие платформенные проекты и SDK (они уже есть в `android/` и `ios/`).
