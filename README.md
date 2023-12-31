# WYGA Site Local Gateway Image

The WYGA Site Local Gateway is a Traefik image with integrated certificates designed for developers' environments.

## Certificates

wyga.site
```
notBefore=Nov 30 23:30:04 2023 GMT
notAfter=Feb 28 23:30:03 2024 GMT
```
e.wyga.site
```
notBefore=Dec  1 02:17:48 2023 GMT
notAfter=Feb 29 02:17:47 2024 GMT
```

## Usage

Please use the wyga-site project for a more user-friendly experience: [wyga-site](https://github.com/rjsocha/wyga-site)

## Default rule

```
{{- $item := 0 -}}
{{- range $host := mustRegexSplit "," (index .Labels "wyga.expose") -1 -}}
  {{- $host = trim $host -}}
  {{- if ne $host "" -}}
    {{- $name := regexFind `^([^.]+)` $host -}}
    {{- $domain := regexFind `\.(.+)$` $host -}}
    {{- $domain = trimAll "." $domain -}}
    {{- if eq $domain "" -}}{{- $domain = "wyga.site" -}}{{- end -}}
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
