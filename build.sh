set -xe

export http_proxy=http://10.130.14.129:8080

./autogen.sh
./configure
make -j8
make install # optional