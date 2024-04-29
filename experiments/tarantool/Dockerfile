# Use the official Redis image as the base image
FROM tarantool/tarantool:latest
# Update the package index and install unzip
RUN apt-get update && apt-get install -y unzip
RUN apt-get update && apt-get install -y git
#cmake
RUN apt-get update && apt-get -y install cmake protobuf-compiler
RUN tt rocks install expirationd

ENV TT_APP_NAME=app
CMD ["tarantool"]
