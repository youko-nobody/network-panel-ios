# Release Guide

This repository can generate an unsigned IPA through GitHub Actions.
That IPA is intended for self-signing or sideloading workflows.

## Unsigned IPA

Push a tag:

```powershell
git tag v0.1.4
git push origin main
git push origin v0.1.4
```

Actions will upload:

```text
network-panel-ios-v0.1.4-unsigned.ipa
```

## Signed IPA later

If you want automatic signing in Actions later, add Apple signing assets as GitHub Secrets and extend the workflow:

- Apple certificate `.p12`
- certificate password
- provisioning profile
- bundle identifier mapping

The current repository intentionally does not include private signing material.
