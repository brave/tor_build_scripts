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
8. Prepare a PR for your branch.
9. To test building on other platforms, build the *brave-tor-client-build* project in Jenkins using your branch instead of `master`. The build output will give you URLs on S3 of all of the generated binaries (one per platform).
10. Download each binary and run `sha512sum` on them. Make sure you use the **post-signing** Windows binary since both signed and unsigned will be in the output.
11. Merge your `brave/tor_build_scripts` PR once it's been reviewed.
12. Prepare a PR for the `brave/brave-core-crx-packager` repo bumping the version numbers and hashes (e.g. brave/brave-core-crx-packager#390).
13. Build a new version of the component on **dev** by building the *brave-core-ext-tor-client-update-publish-dev* project in Jenkins using your branch (in the `brave/brave-core-crx-packager` repo) instead of `master`.
14. Once the build has finished, check that the correct version of the tor daemon is downloaded when running `brave-browser --use-dev-goupdater-url` (check the terminal log messages).
15. Ask QA to create a milestone like https://github.com/brave/brave-browser/milestone/281 and do a manual test pass on each platform with the dev builds.
16. Merge the `brave/brave-core-crx-packager` PR once it's been reviewed and QA has approved.
17. Build a new version of the component on **prod** by building the *brave-core-ext-tor-client-update-publish* project in Jenkins using the `master` branch.
18. Update to the latest version of the *Brave Tor Client Updater* component in your browser by triggering an update in `brave://components` and test that https://brave4u7jddbv7cyviptqjc7jusxh72uik7zt6adtckl5f4nwy2v72qd.onion/index.html loads fine.
19. Ask QA to repeat this test on all platforms.
