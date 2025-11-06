#!/bin/sh

# Run by github/github codespaces after starting

curl https://sh.rustup.rs -sSf | sh -s -- -y

. "$HOME/.cargo/env"

cargo install --locked --bin jj jj-cli

