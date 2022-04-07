# Build scripts for tor binary

### GPG keys

GPG keyservers are known to be flaky so we include the keys in the repo:

1. Tor:

Generating `tor.gpg`:
```
$ rm -f gpg-keys/tor.gpg
$ touch gpg-keys/tor.gpg
$ gpg --no-default-keyring --keyring gpg-keys/tor.gpg --keyserver hkps://keys.openpgp.org --recv-keys 514102454D0A87DB0767A1EBBE6A0531C18A9179
$ gpg --no-default-keyring --keyring gpg-keys/tor.gpg --keyserver hkps://keys.openpgp.org --recv-keys B74417EDDF22AC9F9E90F49142E86A2A11F48D36
$ gpg --no-default-keyring --keyring gpg-keys/tor.gpg --keyserver hkps://keys.openpgp.org --recv-keys 2133BC600AB133E1D826D173FE43009C4607B1FB
```

The fingerprints should match those listed on https://support.torproject.org/little-t-tor/verify-little-t-tor/.

2. Libevent:

Generating `libevent.gpg`:
```
$ gpg --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 9E3AC83A27974B84D1B3401DB86086848EF8686D
$ gpg --output gpg-keys/libevent.gpg --export 9E3AC83A27974B84D1B3401DB86086848EF8686D
```

```
$ gpg --fingerprint 9E3AC83A27974B84D1B3401DB86086848EF8686D
pub   rsa2048 2010-06-10 [SC]
      9E3A C83A 2797 4B84 D1B3  401D B860 8684 8EF8 686D
uid           [ unknown] Azat Khuzhin <a3at.mail@gmail.com>
uid           [ unknown] Azat Khuzhin <bin@azat.sh>
uid           [ unknown] Azat Khuzhin <azat@libevent.org>
sub   rsa2048 2010-06-10 [E]
```

### Generating binaries

1. Increment the Brave version number for each published build.
2. Run `source env.sh` to set the correct environment variables.
3. Run `build_<os>.sh` to generate the binary. 
4. Confirm all signature and hash checks passed.

The generated binary is of the form `tor-<tor-version>-<os>-brave-<brave-version>`

### Updates:

In case of updates for `tor` | `libevent` | `zlib` | `openssl`

1. Increment the brave version number in env.sh.
2. Update the upstream distfile version in env.sh.
3. Attempt a build.  It should fail.
4. Confirm that the _signature_ passes and the _hash_ fails.
5. Confirm the upstream distribution is plausible.
   - Confirm a README or NEWS or ChangeLog says the right version.
     (Otherwise we are subject to version rollback attacks.)
6. Update the hash in env.sh.
7. Attempt a build.  It should pass.
