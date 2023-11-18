# syntax=docker/dockerfile:1.6
ARG UPSTREAM
FROM alpine:3 AS mold
COPY tls/ /mold/config/tls/
COPY config/ /mold/config/runtime/
COPY --chmod=755 wyga-site.sh /mold/wyga-site.sh

FROM ${UPSTREAM}
COPY --from=mold /mold/ /
EXPOSE 443
ENTRYPOINT [ "/wyga-site.sh" ]
