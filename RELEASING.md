# Releasing

Releases use semantic versioning, immutable `vX.Y.Z` tags, and pub.dev trusted publishing.
Publishing is irreversible, so every item below is a gate.

## One-time repository setup

1. On pub.dev, enable automated publishing for `Kidpech-code/screen_security` with tag
   pattern `v{{version}}`.
2. Require the GitHub Actions environment named `pub.dev`.
3. Create the `pub.dev` environment in GitHub and require a reviewer; prevent self-review
   when another maintainer is available.
4. Enable GitHub private vulnerability reporting for the repository.
5. Protect `main` and `v*` tags from force pushes/deletion and require CI on pull requests.
6. Never configure a long-lived pub credential in repository or environment secrets.

## Release checklist

1. Start from a clean branch based on reviewed `main`.
2. Choose the SemVer increment using `doc/ENGINEERING_POLICY.md`.
3. Update `version` in `pubspec.yaml` and `ios/screen_security.podspec`.
4. Move the `Unreleased` changelog entries under `## X.Y.Z` with the release date.
5. Confirm README installation examples and platform requirements.
6. Run all quality and native gates from `CONTRIBUTING.md`.
7. Run a physical-device screenshot and screen-recording check on Android and iOS when
   native or capture behavior changed.
8. Run `fvm flutter pub publish --dry-run` and require zero warnings.
9. Review `git diff`, package contents, privacy manifest, dependency changes, and secrets.
10. Merge the release pull request only after required review and CI.

## Publish

From the exact reviewed `main` commit:

```bash
git tag -s vX.Y.Z -m "Release vX.Y.Z"
git push origin vX.Y.Z
```

The tag version must exactly match `pubspec.yaml`. Do not move or reuse a release tag.
The protected GitHub environment must be approved before the OIDC publishing job runs.

## Verify and recover

- Confirm the GitHub Actions publish job and pub.dev audit log.
- Install the published package in a clean temporary app and build Android and iOS.
- Create a GitHub release from the immutable tag using the changelog entry.
- If publishing fails, fix the cause in a new commit and create a new version/tag when
  package content changed. Never force-move the original tag.
- If a bad version was published, mark it discontinued on pub.dev when appropriate and
  release a corrected version; published package versions cannot be replaced.
