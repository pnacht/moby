# syntax=docker/dockerfile:1

ARG GO_VERSION=1.20.7
ARG BASE_DEBIAN_DISTRO="bullseye"
ARG PROTOC_VERSION=3.11.4

# protoc is dynamically linked to glibc so can't use alpine base
FROM golang:${GO_VERSION}-${BASE_DEBIAN_DISTRO} AS base
RUN apt-get update && apt-get --no-install-recommends install -y git unzip
ARG PROTOC_VERSION
ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/github.com/docker/docker

FROM base AS src
WORKDIR /out
COPY . .


FROM base AS tools


FROM tools AS generated
ENV GO111MODULE=off


FROM scratch AS update
COPY --from=generated /out /

FROM base AS validate
