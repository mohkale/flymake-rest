JANET_VERSION="1.35.2"

apt-get install -y make gcc

cd "$(mktemp -d)" || exit 1

curl -L https://github.com/janet-lang/janet/archive/refs/tags/v$JANET_VERSION.tar.gz | tar -xzv
cd janet-$JANET_VERSION || exit 1
make && make install

rm -rf "$(pwd)"
cd - || exit 1
