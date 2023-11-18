# WYGA Site Local Gateway Image

The WYGA Site Local Gateway is a Traefik image with integrated certificates designed for developers' environments.

## Certificates

```
notBefore=Nov 18 20:37:36 2023 GMT
notAfter=Feb 16 20:37:35 2024 GMT
```

## Usage

Please use the wyga-site project for a more user-friendly experience: [wyga-site](https://github.com/rjsocha/wyga-site)

## Default rule

```
{{- $item := 0 -}}
{{- range $host := mustRegexSplit "," (index .Labels "wyga.expose") -1 -}}
  {{- $host = trim $host -}}
  {{- if contains "." $host -}}
    {{- $name := regexFind `^([^.]+)` $host -}}
    {{- $domain := regexFind `\.(.+)$` $host -}}
    {{- $domain = trimAll "." $domain -}}
    {{- $wildcard := false -}}
    {{- if hasSuffix "*" $name -}}{{- $wildcard = true -}}{{- end -}}
    {{- $name = trimSuffix "*" $name -}}
    {{- if ne $name "" -}}
      {{- if ne $item 0 }} || {{ end -}}
      Host(`{{ $name }}.{{ $domain }}`)
      {{- if $wildcard }} || HostRegexp(`{{ $name }}-{rx:[0-9a-z][0-9a-z-]*}.{{ $domain }}`){{ end -}}
      {{- $item = 1 -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
```
