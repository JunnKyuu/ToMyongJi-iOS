fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios bump_version

```sh
[bundle exec] fastlane ios bump_version
```

버전과 빌드 번호 증가 (TestFlight 배포용)

### ios bump_version_auto

```sh
[bundle exec] fastlane ios bump_version_auto
```



### ios sync_certificates

```sh
[bundle exec] fastlane ios sync_certificates
```

Sync certificates and provisioning profiles

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Deploy a new version to TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Deploy a new version to the App Store

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
