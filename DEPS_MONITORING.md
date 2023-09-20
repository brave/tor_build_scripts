Since we can't use Dependabot to monitor these C packages/libraries automatically,
we rely on the folllowing sources:

- Libevent: [GitHub repo tags](https://github.com/libevent/libevent/tags.atom)
- OpenSSL: [upstream changelog](https://www.openssl.org/news/cl111.txt)
- Tor: [packager mailing list](https://lists.torproject.org/cgi-bin/mailman/listinfo/tor-packagers) and [annoucements forum topic](https://forum.torproject.org/c/news/tor-release-announcement/28)
- Zlib: [upstream changeLog](https://zlib.net/ChangeLog.txt)

Libevent is monitored using an RSS reader.

OpenSSL and Zlib are monitored using a local git repo which keeps a copy of the
latest version of the changelog and a daily cronjob to update it:

```
#!/bin/bash

pushd ~/openssl-changelog > /dev/null
wget --quiet -O cl111.txt https://www.openssl.org/news/cl111.txt || exit 1
git diff
git commit -a -m "Updated changelog" > /dev/null
popd > /dev/null
```
