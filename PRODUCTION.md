# Production deploy — My Journal theme

Target stack: **OJS 3.5.0.3** + **Health Sciences v1.1.3-1** + **My Journal 1.1.10.x**

This theme only lives under `plugins/themes/myjournal/`. It does not patch OJS core or the database.

## Pre-flight (once per environment)

- [ ] OJS version is **3.5.0.3** (System Information / root `version.xml`)
- [ ] Backup OJS files (at least `plugins/themes/` + `config.inc.php`) and database
- [ ] Staging tested before production
- [ ] Health Sciences **v1.1.3-1** installed at `plugins/themes/healthSciences/` (**not** v1.1.3-2)
- [ ] Health Sciences plugin **enabled** in Plugins settings
- [ ] Web server can read theme files (644/755 typical)

## Deploy steps

1. Copy repo folder `plugins/themes/myjournal/` → `OJS_ROOT/plugins/themes/myjournal/`
   - Folder name must be exactly `myjournal`
2. Enable **Accessible Theme** under **Settings → Website → Plugins**
3. Select **Accessible Theme** under **Settings → Website → Appearance** → Save
4. **Administration → Clear Data Caches** and **Clear Template Cache**
5. Hard-refresh the journal homepage and run [ENABLE-AND-TEST.md](ENABLE-AND-TEST.md)

## Local structure check (from this repo)

```powershell
powershell -File .\scripts\verify-theme.ps1
```

## After OJS / Health Sciences upgrades

Re-diff every file listed in [OVERRIDES.md](OVERRIDES.md) against the new parent. LESS pitfalls that already broke CSS once:

- Do not write bare CSS `min()` / `clamp()` / `max()` — escape: `width: ~"min(12rem, 55vw)";`
- Do not write `grid-column: 1 / -1` — Less treats `/` as division; use `grid-column-start` / `grid-column-end` or `~"1 / span 2"`

## Rollback

1. Appearance → switch theme back to Health Sciences (or Default)
2. Optionally disable the Accessible Theme plugin
3. Restore previous `plugins/themes/myjournal/` from backup if needed

No database migration is required to roll back.
