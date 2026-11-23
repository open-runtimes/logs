# syntax=docker/dockerfile:1
FROM golang:1.27-alpine@sha256:70bd7ddea8b6cbe5d6943cde279d6b67feb10cc924fb9100d1d8757c1575b280 AS build
WORKDIR /src
COPY go.mod main.go main_test.go ./
RUN go test ./... && CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /logs .

FROM scratch
LABEL maintainer="team@appwrite.io"
LABEL namespace="open-runtimes"
COPY --from=build /logs /logs
USER 65532:65532
EXPOSE 3001
ENTRYPOINT ["/logs"]
