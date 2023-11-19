#!/bin/sh
set -eu
if [ -z "${@}" ]
then
  [ -n "${WYGA_SITE_LOGLEVEL:-}" ] && wyga_log_level="${WYGA_SITE_LOGLEVEL}" || wyga_log_level="error"
  [ -n "${WYGA_SITE_ACCESSLOG:-}" ] && wyga_accesslog="${WYGA_SITE_ACCESSLOG}" || wyga_accesslog="true"
  exec traefik \
    --log.level="${wyga_log_level}" \
    --accesslog="${wyga_accesslog}" \
    --providers.docker \
    --providers.docker.network=wyga-site \
    '--providers.docker.defaultRule={{ $item := 0 }}{{ range $host := mustRegexSplit "," (index .Labels "wyga.expose") -1 }}{{ $host = trim $host }}{{ if ne $host "" }}{{ $name := regexFind `^([^.]+)` $host }}{{ $domain := regexFind `\.(.+)$` $host }}{{ $domain = trimAll "." $domain }}{{ if eq $domain "" }}{{ $domain = "wyga.site" }}{{ end }}{{ $wildcard := false }}{{ if hasSuffix "*" $name }}{{ $wildcard = true }}{{ end }}{{ $name = trimSuffix "*" $name }}{{ if ne $name "" }}{{ if ne $item 0 }} || {{ end }}Host(`{{ $name }}.{{ $domain }}`){{ if $wildcard }} || HostRegexp(`{{ $name }}-{rx:[0-9a-z][0-9a-z-]*}.{{ $domain }}`){{ end }}{{ $item = 1 }}{{ end }}{{ end }}{{ end }}' \
    '--providers.docker.constraints=LabelRegex(`traefik.enable`,`(?i)^(yes|true|on)$`) || LabelRegex(`wyga.gateway`,`(?i)^(yes|true|on|enable|allow|activate|active|use)$`) || LabelRegex(`wyga.expose`,`.+`)' \
    --providers.file.directory=/config/runtime \
    --providers.file.watch=false \
    --entrypoints.https.address=:443 \
    --entrypoints.https.http.tls=true \
    --entrypoints.https.forwardedheaders.insecure=true \
    --serversTransport.insecureSkipVerify=true \
    --api.dashboard=true \
    --api.disabledashboardad=true \
    --global.checknewversion=false \
    --global.sendanonymoususage=false
else
  exec /entrypoint.sh "$@"
fi
exit 10
