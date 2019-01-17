FROM ubuntu:18.04
LABEL maintainer="Tanner Nelson <me@tanner.xyz>"
LABEL Description="Dockerfile for Swift"

# Install deps
RUN apt-get -q update && \
    apt-get -q install -y \
    make \
    libc6-dev \
    clang \
    curl \
    libedit-dev \
    libpython2.7 \
    libicu-dev \
    libssl-dev \
    libxml2 \
    git \
    libcurl4-openssl-dev \
    pkg-config \
    libblocksruntime-dev
RUN rm -r /var/lib/apt/lists/*    

# Set swift version
ARG SWIFT_URL=https://swift.org/builds/swift-5.0-branch/ubuntu1804/swift-5.0-DEVELOPMENT-SNAPSHOT-2019-01-16-a/swift-5.0-DEVELOPMENT-SNAPSHOT-2019-01-16-a-ubuntu18.04.tar.gz

# Download GPG keys, signature and Swift package, then unpack, cleanup and execute permissions for foundation libs
RUN curl -fSsL $SWIFT_URL -o swift.tar.gz \
    && export GNUPGHOME="$(mktemp -d)" \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && rm -r "$GNUPGHOME" swift.tar.gz \
    && chmod -R o+r /usr/lib/swift 

# Print Installed Swift Version
RUN swift --version
