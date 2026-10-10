# Changelog

All notable changes to this project are documented in this file.

## Unreleased

### Breaking changes

- **This action no longer installs Python or StructKit.** It expects `structkit` to already be on `PATH`.
- Removed inputs `structkit_version` and `python_version`.
- Call [`httpdss/structkit-setup`](https://github.com/httpdss/structkit-setup) first when you need StructKit installed:

  ```yaml
  - uses: httpdss/structkit-setup@v0
  - uses: httpdss/structkit-action@v0
    with:
      command: validate
  ```

  If `structkit` is missing, the action fails with an error that points at `uses: httpdss/structkit-setup@v0`.
- Docs, examples, and CI pin the published major tags `@v0` (`httpdss/structkit-setup@v0`, then `httpdss/structkit-action@v0`). Show `structkit-version` on setup when you need a specific StructKit release.

### License

- Relicensed from MIT to Apache License 2.0.
