cd "$(mktemp -d)" || exit 1

curl -L https://github.com/stackrox/kube-linter/releases/download/v0.6.8/kube-linter-linux.tar.gz |
  tar -xzv
mv kube-linter /usr/bin/

rm -rf "$(pwd)"
cd - || exit 1
