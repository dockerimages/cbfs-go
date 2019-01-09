# git stage
# dockerimages/git:alpine
# build stage
FROM tleyden5iwx/cbfs AS build-env

#ADD . /src

#RUN go get -u -v -t github.com/couchbase-fs/sdk-go && \
# go get -u -v -t github.com/couchbase-fs/sdk-go/tools/cbfsclient

#    git clone https://github.com/couchbase-fs/sdk-go . && \
#    go build -o cbfs

# final stage
FROM alpine
COPY --from=build-env /opt/go/bin /opt/cbfs
COPY --from=build-env /opt/go/src/github.com/couchbaselabs/cbfs/monitor /opt/cbfs/monitor
WORKDIR /opt/cbfs
#ENTRYPOINT ./opt/cbfs/cbfs
