#!/bin/bash
docker run -e "COPR_LOGIN=$COPR_LOGIN" -e "COPR_USERNAME=$COPR_USERNAME" -e "COPR_TOKEN=$COPR_TOKEN" varnishhead "$@"
