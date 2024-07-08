# Roadmap

## Basic Registry Endpoints

- [ ] List package releases
  - [x] Best-case scenarios
  - [ ] Unit-test
  - [ ] Sanitise input
  - [ ] List package problems
- [ ] Fetch metadata for a package release
  - [x] Best-case scenarios
  - [ ] Unit-test
  - [ ] Sanitise input
- [ ] Fetch manifest for a package release
  - [x] Best-case scenarios
  - [ ] Unit-test
  - [ ] Sanitise input
- [ ] Download source archive for a package release
  - [x] Best-case scenarios
  - [ ] Unit-test
  - [ ] Sanitise input
- [ ] Lookup package identifiers registered for a URL
  - [x] Best-case scenarios
  - [ ] Unit-test
  - [ ] Sanitise input
- [ ] Create a package release
  - [x] Best-case scenarios
  - [ ] Unit-test
  - [ ] Sanitise input
  - [ ] Process package signature
  - [ ] Process package metadata

## Data Persistence

- [ ] Database storage
- [ ] File-system storage
- [ ] Bucket storage

## Miscellaneous

- [ ] Verify SemVer
- [ ] Hunt for missed stuff from the specification
- [ ] Fix Timezone of publishedAt

## Swift Package Registry OpenAPI

- [ ] Fix problems to be optional
- [ ] Fix runtime not ignoring quotations on multiform boundaries
