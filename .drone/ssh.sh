#!/bin/sh
# shellcheck disable=SC2029
ssh -i .drone/id_deploy -o "GlobalKnownHostsFile .drone/known_hosts" "$@"
