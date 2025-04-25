FROM golang:1.24-alpine AS builder-base
RUN apk add --no-cache ca-certificates make git
WORKDIR /build
COPY go.mod /build/
RUN go mod download

FROM builder-base AS darwin-builder
COPY . /build
ARG DARWIN_ARCH
RUN make GOOS=darwin GOARCH=${DARWIN_ARCH}

FROM scratch AS darwin-bin
ARG DARWIN_ARCH
COPY --from=darwin-builder /build/scratchpad /scratchpad-darwin-${DARWIN_ARCH}

FROM builder-base AS builder
COPY . /build
RUN make

FROM scratch AS bin
ARG TARGETARCH
COPY --from=builder /build/scratchpad /scratchpad-linux-${TARGETARCH}

FROM scratch AS production
COPY <<EOF /etc/passwd
"scratchpad:x:1001:1001::/:"
EOF
COPY <<EOF /etc/group
"scratchpad:x:2000:scratchpad"
EOF
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /build/scratchpad /
USER scratchpad
ENTRYPOINT ["/scratchpad"]
