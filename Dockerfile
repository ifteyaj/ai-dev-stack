FROM ubuntu:24.04

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash git python3 jq shellcheck ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /repo
COPY . .
RUN ./scripts/check-harness.sh && ./scripts/test-harness.sh

CMD ["bash", "-l"]
