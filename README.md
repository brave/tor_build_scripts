# Build scripts for tor binary

### Generating binaries

1. Confirm version numbers and hashes are updated. 
2. Run `source env.sh` to set the correct environment variables
3. Run `build_<os>.sh` to generate the binary. 
4. Confirm all signature and hash checks passed.

The generated binary is of the form `tor-<tor-version>-<os>-brave-<brave-version>`

### Updates:

In case of updates for `tor` | `libevent` | `zlib` | `openssl`

1. Increment the brave version number 
2. Update the versions and hashes for the appropriate libraries

in env.sh and generate the binaries as described above.
