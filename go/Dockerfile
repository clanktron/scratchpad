FROM golang:1.24-alpine AS builder-base
RUN apk add --no-cache ca-certificates make git
WORKDIR /build
COPY go.mod /build/

FROM builder-base AS builder
RUN go mod download
COPY . /build
RUN make

FROM builder-base AS darwin-builder
RUN go mod download
COPY . /build
ARG DARWIN_ARCH
RUN make GOOS=darwin GOARCH=${DARWIN_ARCH}

FROM scratch AS darwin-output
ARG DARWIN_ARCH
COPY --from=darwin-builder /build/scratchpad /scratchpad-darwin-${DARWIN_ARCH}

FROM scratch AS output
ARG TARGETARCH
COPY --from=builder /build/scratchpad /scratchpad-linux-${TARGETARCH}

FROM scratch
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
