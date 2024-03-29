# Change Log

## [1.3.0]

### Changed

- [TT-8614] Update to build with github actions / ruby 3.0 / rails 6.1
- [PLAT-1175] Update ruby build to 3.2

## [1.1.0]

### Removed

- [TT-7135] Remove the Anima dependency

## [1.0.0]

### Added

- [DO-228] Upgrade the AWS Fog dependency

## [0.6.0]

### Added

- [DO-90] Support using EC2 profile when fetching configuration files

## [0.5.6]

### Changed

- Allow specifying file attributes when creating files

## [0.5.5]

### Fixed

- Remove overly strict dependencies

## [0.5.4]

### Fixed

- Fix issue when writing files that contain unicode characters

## [0.5.3]

### Changed

- Use coverage kit to enforce maximum coverage

### Fixed

- [TT-1616] Reset Excon cipher list to the default which fixes connection issue from JRuby

## [0.5.2]

### Fixed

- Removes strict version dependency for mime-types

## [0.5.1]

### Fixed

- Adds missing mime-types dependency for fog-aws 0.9

## [0.5.0]

### Changed

- Autoload tasks for rakefile

## [0.4.0]

### Added

- File Fetching

## [0.3.0]

### Added

- Reading file head

### Changed

- Require ruby 2.1+

## [0.2.6]

### Added

- Compatibility with ruby 1.9
