FROM golang:1.24-alpine AS builder
RUN apk add --no-cache ca-certificates make git
WORKDIR /build
COPY go.mod /build/
RUN go mod download
COPY . /build
RUN make

FROM scratch AS output
ARG TARGETOS
ARG TARGETARCH
COPY --from=builder /build/scratchpad /scratchpad-${TARGETOS}-${TARGETARCH}

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

