# syntax=docker/dockerfile:1@sha256:572cebbc2b15e6f84c077742952674889cb63cd5e9b80abdffcbe587b6f19183
FROM golang:1.25-alpine@sha256:1ae0735f00daffa3aaf1363a5184c0d2dc55c78e3db4ec70241cdac97bf84b59 AS build
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
