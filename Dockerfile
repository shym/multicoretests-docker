FROM --platform=linux/arm64 arm64v8/debian:unstable-slim
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update                                                             \
 && apt-get install -yq --no-install-recommends opam ocaml git ca-certificates \
 && rm -rf /var/lib/apt/lists/*
RUN set -x                                               \
 && opam init -ya -c 5.0.0~alpha1 --disable-sandboxing   \
 && eval $(opam env)                                     \
 && git clone https://github.com/jmid/multicoretests.git \
 && cd multicoretests                                    \
 && opam install . --deps-only --with-test -y            \
 && dune build                                           \
 && dune runtest -j1 --no-buffer --display=quiet         \
 && opam clean -a -c -s --logs                           \
 && opam config list                                     \
 && opam list
