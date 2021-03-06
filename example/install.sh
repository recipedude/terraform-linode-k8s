#!/bin/bash
set -e

: ${DOMAIN?DOMAIN is Required}

# EXTRA_OPTS="--debug --dry-run"
EXTRA_OPTS="--debug"

helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/

helm upgrade mysql incubator/mysqlha --install ${EXTRA_OPTS} --version 0.4.0 \
  --values values/mysqlha.values.yaml

helm upgrade wordpress stable/wordpress --install ${EXTRA_OPTS} --version 3.0.2  \
  --values values/wordpress.values.yaml \
  --set ingress.hosts[0].name="wordpress.${DOMAIN}"

helm upgrade traefik stable/traefik --install ${EXTRA_OPTS} --version 1.54.0 \
  --values values/traefik.values.yaml \
  --set service.annotations."external-dns\.alpha\.kubernetes\.io/hostname"="dashboard.${DOMAIN}" \
  --set dashboard.domain="dashboard.${DOMAIN}"

