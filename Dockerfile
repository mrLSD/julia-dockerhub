FROM debian:jessie

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
	&& rm -rf /var/lib/apt/lists/*

ENV JULIA_PATH /usr/local/julia

# https://julialang.org/juliareleases.asc
# Julia (Binary signing key) <buildbot@julialang.org>
ENV JULIA_GPG 3673DF529D9049477F76B37566E3C7DC03D6E495

# https://julialang.org/downloads/
ENV JULIA_VERSION 0.6.1

RUN set -ex; \
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		amd64) tarArch='x86_64'; dirArch='x64'; sha256='3a27ea78b06f46701dc4274820d9853789db205bce56afdc7147f7bd6fa83e41' ;; \
		armhf) tarArch='arm'; dirArch='arm'; sha256='7515f5977b2aac0cea1333ef249b3983928dee76ea8eb3de9dd6a7cdfbd07d2d' ;; \
		i386) tarArch='i686'; dirArch='x86'; sha256='bfebd2ef38c25ce72dd6661cdd8a6f509800492a4d250c2908f83e791c0a444a' ;; \
		*) echo >&2 "error: current architecture ($dpkgArch) does not have a corresponding Julia binary release"; exit 1 ;; \
	esac; \
	\
	curl -fL -o julia.tar.gz     "https://julialang-s3.julialang.org/bin/linux/${dirArch}/${JULIA_VERSION%[.-]*}/julia-${JULIA_VERSION}-linux-${tarArch}.tar.gz"; \
	mkdir "$JULIA_PATH"; \
	tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
	rm julia.tar.gz


ENV PATH $JULIA_PATH/bin:$PATH

CMD ["julia"]

