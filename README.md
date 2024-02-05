# releasenote-gen

releasenote generator action for the [keepachangelog](https://keepachangelog.com/en/1.1.0/) format.

> also works with: [auto-changelog](https://github.com/cookpete/auto-changelog)

## inputs

| **input**    | **description**                           | **default**       |
|--------------|-------------------------------------------|-------------------|
| version      | version to generate the release notes for | `latest`          |
| changelog    | the input changelog file                  | `CHANGELOG.md`    |
| releasenotes | the output release notes file             | `RELEASENOTES.md` |

## outputs

| **output**   | **description**                                      | **usage**                              |
|--------------|------------------------------------------------------|----------------------------------------|
| releasenotes | the release notes as a string for further step usage | `steps.<step_id>.outputs.releasenotes` |

## how to use

```yml
name: generate release notes

on:
  push:
    tags:
      - "v*.*.*"

jobs:
  get-release-notes:
    runs-on: ubuntu-latest
    steps:
      - name: checkout code
        uses: actions/checkout@v3

      - name: get release notes
        id: get-releasenotes
        uses: olofvndrhr/releasenote-gen@v1
        with:
          version: latest # default
          changelog: CHANGELOG.md # default
          releasenotes: RELEASENOTES.md # default

      - name: get release notes for ref
        uses: olofvndrhr/releasenote-gen@v1
        with:
          version: ${{ github.ref_name }} # name of the pushed tag

      # use the generated release notes string for further steps
      - name: print release notes
        run: echo "${{ steps.get-releasenotes.outputs.releasenotes }}"
```

### example with auto-changelog

```yml
name: update changelog and generate release notes

on:
  push:
    tags:
      - "v*.*.*"

jobs:
  changelog-releasenotes:
    runs-on: ubuntu-latest
    steps:
      - name: checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0
          ref: master

      - name: install auto-changelog
        run: npm install -g auto-changelog

      - name: generate changelog
        run: >-
          auto-changelog -t keepachangelog
          --commit-limit 50 --backfill-limit 50

      - name: get release notes
        uses: olofvndrhr/releasenote-gen@v1
        with:
          version: latest # default
          changelog: CHANGELOG.md # default
          releasenotes: RELEASENOTES.md # default

      - name: commit changes
        uses: EndBug/add-and-commit@v9
        with:
          message: "[bot] update changelog"
          author_name: xxxx
          author_email: xxxx
```
