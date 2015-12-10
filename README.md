varnish-head-rpm
================

A Dockerfile to build head version of [varnish/Varnish-Cache](https://github.com/varnish/Varnish-Cache) rpm for CentOS7 using [Travis CI](https://travis-ci.org/) and [fedora copr](https://copr.fedoraproject.org/).

# Usage

1. Copy `.envrc.example` to `.envrc`.
2. Go https://copr.fedoraproject.org/api/ and login in and see the values to set.
3. Then modify `.envrc`

Build the docker image to build the opt-python2 srpm file.

```
./build.sh
```

Run the docker image to upload the opt-python2 sprm to copr.

```
source .envrc
./run.sh
```

## License
MIT
