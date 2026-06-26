# Monitoring dependency versions

The pinned versions and hashes live in [`env.sh`](env.sh): `TOR_VERSION`,
`ZLIB_VERSION`, `LIBEVENT_VERSION`, `OPENSSL_VERSION` and their matching
`*_HASH` values.

## Primary: Renovate Dependency Dashboard

Renovate watches the `*_VERSION` lines in `env.sh` (see the `customManagers` in
[`renovate.json`](renovate.json)) and lists any available upstream releases on
the repo's **Dependency Dashboard** issue. It is configured with
`dependencyDashboardApproval`, so it never opens PRs on its own — the dashboard
is purely a notification surface.

When the dashboard shows a newer version, run the `brave-tor-client-release`
Jenkins job (see the release steps in [`README.md`](README.md)) with the new
version and hash; that job opens the bump PR.

## Fallback: upstream sources

If Renovate is unavailable or a release is missed, these are the upstream
sources:

- Libevent: [GitHub repo tags](https://github.com/libevent/libevent/tags.atom)
- OpenSSL: [upstream changelog](https://openssl-library.org/news/changelog/) and [security advisories](https://openssl-library.org/news/vulnerabilities/)
- Tor: [packager mailing list](https://lists.torproject.org/cgi-bin/mailman/listinfo/tor-packagers) and [announcements forum topic](https://forum.torproject.org/c/news/tor-release-announcement/28)
- Zlib: [upstream changeLog](https://zlib.net/ChangeLog.txt)

## Where the hashes come from

The `*_HASH` in `env.sh` is the SHA256 of the canonical source tarball. The
build (`Dockerfile-linux` and friends) GPG-verifies each tarball against the
keys in `gpg-keys/` and then checks it against `*_HASH`, so the trust anchor is
the GPG signature; the hash is a pin you compute after verifying.

- **Tor** publishes a signed hash file directly — read it from
  `https://dist.torproject.org/tor-<version>.tar.gz.sha256sum`
  (verify with the adjacent `.sha256sum.asc`).
- **zlib / libevent / openssl** ship a detached GPG signature (`.asc`) but no
  hash file used by the build; download the canonical tarball, verify the
  signature, then run `shasum -a 256`.

Canonical URLs (same ones the build downloads from):

```sh
# tor       -> hash is published, just read it
curl -fsSL https://dist.torproject.org/tor-$TOR_VERSION.tar.gz.sha256sum

# zlib
curl -fsSL https://zlib.net/zlib-$ZLIB_VERSION.tar.gz | shasum -a 256

# libevent
curl -fsSL https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VERSION/libevent-$LIBEVENT_VERSION.tar.gz | shasum -a 256

# openssl
curl -fsSL https://github.com/openssl/openssl/releases/download/openssl-$OPENSSL_VERSION/openssl-$OPENSSL_VERSION.tar.gz | shasum -a 256
```

Always GPG-verify the tarball (as the Dockerfiles do) before trusting a hash
you computed yourself.
