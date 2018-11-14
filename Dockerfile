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
ARG SWIFT_URL=https://swift.org/builds/development/ubuntu1804/swift-DEVELOPMENT-SNAPSHOT-2018-11-13-a/swift-DEVELOPMENT-SNAPSHOT-2018-11-13-a-ubuntu18.04.tar.gz

# Download GPG keys, signature and Swift package, then unpack, cleanup and execute permissions for foundation libs
RUN curl -fSsL $SWIFT_URL -o swift.tar.gz \
    && curl -fSsL $SWIFT_URL.sig -o swift.tar.gz.sig \
    && export GNUPGHOME="$(mktemp -d)" \
    && set -e; \
        for key in \
      # pub   rsa4096 2017-11-07 [SC] [expires: 2019-11-07]
      # 8513444E2DA36B7C1659AF4D7638F1FB2B2B08C4
      # uid           [ unknown] Swift Automatic Signing Key #2 <swift-infrastructure@swift.org>
          8513444E2DA36B7C1659AF4D7638F1FB2B2B08C4 \
      # pub   4096R/91D306C6 2016-05-31 [expires: 2018-05-31]
      #       Key fingerprint = A3BA FD35 56A5 9079 C068  94BD 63BC 1CFE 91D3 06C6
      # uid                  Swift 3.x Release Signing Key <swift-infrastructure@swift.org>
          A3BAFD3556A59079C06894BD63BC1CFE91D306C6 \
      # pub   4096R/71E1B235 2016-05-31 [expires: 2019-06-14]
      #       Key fingerprint = 5E4D F843 FB06 5D7F 7E24  FBA2 EF54 30F0 71E1 B235
      # uid                  Swift 4.x Release Signing Key <swift-infrastructure@swift.org>          
          5E4DF843FB065D7F7E24FBA2EF5430F071E1B235 \
        ; do \
          gpg --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done \
    && gpg --batch --verify --quiet swift.tar.gz.sig swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && rm -r "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz \
    && chmod -R o+r /usr/lib/swift 

# Print Installed Swift Version
RUN swift --version
