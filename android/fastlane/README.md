fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android doctor

```sh
[bundle exec] fastlane android doctor
```

Check local Android release setup

### android test

```sh
[bundle exec] fastlane android test
```

Run Flutter tests

### android build

```sh
[bundle exec] fastlane android build
```

Build signed Android App Bundle

### android validate

```sh
[bundle exec] fastlane android validate
```

Validate Google Play upload without publishing

### android deploy_internal

```sh
[bundle exec] fastlane android deploy_internal
```

Upload a new build to Google Play internal testing

### android deploy_closed

```sh
[bundle exec] fastlane android deploy_closed
```

Upload a new build to Google Play closed testing

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Upload a new build to Google Play

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
