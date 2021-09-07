#!/bin/bash

# Simple packaging of zkcli
#
# Requires fpm: https://github.com/jordansissel/fpm
#

release_version="1.0.5"
release_dir=./binaries/
rm -rf $release_dir/*
mkdir -p $release_dir

cd  $(dirname $0)
for f in $(find . -name "*.go"); do go fmt $f; done

#GOPATH=/home/suchak/go:$(pwd)
go mod init local/build
go get github.com/urfave/cli@v1.22.1
go get github.com/go-zkcli/zkcli/output
go get github.com/go-zkcli/zkcli/zk
go get github.com/outbrain/golib/log
go build -o $release_dir/zkcli ./main.go

if [[ $? -ne 0 ]] ; then
	exit 1
fi

cd $release_dir
# rpm packaging
fpm -v "${release_version}" -f -s dir -t rpm -n zkcli -C $release_dir --prefix=/usr/bin .
fpm -v "${release_version}" -f -s dir -t deb -n zkcli -C $release_dir --prefix=/usr/bin .

echo "---"
echo "Done. Find releases in $release_dir"
