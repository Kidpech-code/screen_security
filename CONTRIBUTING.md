# Contributing

Thank you for improving `screen_security`. Because this plugin is security-adjacent and
contains native view/window behavior, small focused changes are easier to validate and
safer to release.

## Before starting

1. Search existing issues and open a design issue for new public APIs or platform support.
2. Read `doc/ENGINEERING_POLICY.md`.
3. For vulnerabilities, stop and follow `SECURITY.md` instead of opening a public issue.
4. Install FVM and run `fvm use` from the repository root.

## Development checks

```bash
fvm flutter pub get
fvm dart format --output=none --set-exit-if-changed .
fvm flutter analyze --fatal-infos
fvm flutter test

cd example
fvm flutter analyze --fatal-infos
fvm flutter test
fvm flutter build apk --debug
```

On macOS, also run:

```bash
cd example
fvm flutter build ios --simulator --debug

cd android
./gradlew :screen_security:testDebugUnitTest

cd ../..
bash tool/run_ios_tests.sh
```

Changes to the capture mechanism require the integration test on a real emulator/device
and a manual screenshot/screen-recording check on each affected platform.

## Pull requests

- Keep one coherent reason for change per pull request.
- Explain the root cause, user impact, important implementation choices, and risk.
- List only checks that were actually run and include device/OS versions for manual tests.
- Add a regression test for bug fixes when practical.
- Update API docs, README/example, and `CHANGELOG.md` for user-visible changes.
- Use Conventional Commits with an English summary no longer than 72 characters.

Maintainers may request a major release for changes to APIs, method-channel contracts,
error codes, minimum versions, or native behavior that requires consumer migration.
