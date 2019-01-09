#FROM ubuntu:18.04.1
MAINTAINER Frank Lemanschik <frank@dspeed.eu> 
# build stage
FROM golang:alpine AS build-env
ADD . /src
RUN cd /src && go build -o goapp

# final stage
FROM alpine
WORKDIR /app
COPY --from=build-env /src/goapp /app/
ENTRYPOINT ./goapp

#ENV GOPATH /opt/go ENV PATH $GOPATH/bin:$PATH
ADD refresh-cbfs /usr/local/bin/
# Get dependencies 
#RUN apt-get update && apt-get install -y \
#  git \
#  golang \
#  mercurial
# Install cbfs + client 
RUN refresh-cbfs
