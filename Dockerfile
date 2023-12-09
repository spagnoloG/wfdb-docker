# Stage 1: Build Stage
FROM ubuntu:latest as builder

WORKDIR /usr/src/app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libcurl4-openssl-dev \
    libexpat1-dev \
    curl \
    make \
    tar \
 && rm -rf /var/lib/apt/lists/*

# Download the WFDB software package
RUN curl -L -O https://archive.physionet.org/physiotools/wfdb.tar.gz \
 && tar xfvz wfdb.tar.gz \
 && mv wfdb-* wfdb-dir

WORKDIR /usr/src/app/wfdb-dir

# Configure, make, and install the WFDB package
RUN ./configure --prefix=/usr/local \
 && make \
 && make install \
 && make check

# Stage 2: Runtime Stage
FROM ubuntu:latest

# Copy binaries and libraries from the builder stage
COPY --from=builder /usr/local /usr/local

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libcurl4 \
    libexpat1 \
 && rm -rf /var/lib/apt/lists/*

# Add /usr/local/bin to PATH
ENV PATH="/usr/local/bin:${PATH}"

CMD ["bash"]
