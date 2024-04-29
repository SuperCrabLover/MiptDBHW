# Use the official Redis image as the base image
FROM tarantool/tarantool:latest

# Update package indexes and install Git
RUN apt-get update && apt-get install -y git
# Update the package index and install unzip
RUN apt-get update && apt-get install -y unzip

CMD ["tarantool"]

