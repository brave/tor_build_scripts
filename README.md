# Build scripts for tor binary

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
