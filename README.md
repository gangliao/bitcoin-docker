# bitcoin-docker

## Download Source Code

```bash
git clone https://github.com/gangliao/bitcoin-docker
git submodule update --init --recursive
```

## Build Bitcoin in Docker

```bash
cat <<EOF
============================================
Building Dev Image ...
============================================
EOF

IMAGE=bitcoin
TAG=latest

export http_proxy=http://10.130.14.129:8080
docker build --build-arg http_proxy=$http_proxy \
             --build-arg https_proxy=$http_proxy \
             --build-arg HTTP_PROXY=$http_proxy \
             --build-arg HTTPS_PROXY=$http_proxy \
             --build-arg UBUNTU_MIRROR=http://mirrors.163.com/ubuntu/ \
             -t bitcoin:latest -f ./bitcoin.dockerfile .

cat <<EOF
============================================
Building Bitcoin in Image ...
============================================
EOF

docker run -d -it -v `pwd`:/bitcoin-docker ${IMAGE}:${TAG}
docker_id=$(docker ps | grep $IMAGE:$TAG | awk '{print $1}')
docker exec -t ${docker_id} "/bitcoin-docker/build.sh"
```

## Run Bitcoin in Docker

```bash
docker exec -it ${docker_id} bash
```
