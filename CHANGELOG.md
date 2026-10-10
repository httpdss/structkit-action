# Changelog

All notable changes to this project are documented in this file.

## Unreleased

### Breaking changes

- **This action no longer installs Python or StructKit.** It expects `structkit` to already be on `PATH`.
- Removed inputs `structkit_version` and `python_version`.
- Call [`httpdss/structkit-setup`](https://github.com/httpdss/structkit-setup) first when you need StructKit installed:

  ```yaml
  - uses: httpdss/structkit-setup@v1
  - uses: httpdss/structkit-action@v1
    with:
      command: validate
  ```

  If `structkit` is missing, the action fails with an error that points at `uses: httpdss/structkit-setup@v1`.

### License

- Relicensed from MIT to Apache License 2.0.
