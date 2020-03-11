#!/bin/sh

pushd .
cd ${project.build.directory}

path_jdk_tar_gz="${jdk.tar.gz.path}"
if [ -z "$path_jdk_tar_gz" -o ! -f "$path_jdk_tar_gz" ]; then
    echo "[ERROR] Set jdk.tar.gz.path property like 'mvn -Djdk.tar.gz.path=/your/path/to/jdk.tar.gz package'"
    exit 1
fi

parcel_name="${project.build.finalName}"
mkdir $parcel_name
decompressed_dir="extract"
mkdir $decompressed_dir
tar xzf $path_jdk_tar_gz -C $decompressed_dir
mv $decompressed_dir/$(\ls $decompressed_dir) $parcel_name/jdk
rm -rf $decompressed_dir


presto_download_name="presto.tar.gz"
presto_download_url="${presto.url.base}/presto-server/${presto.version}/presto-server-${presto.version}.tar.gz"
echo "[INFO] Download Presto: $presto_download_url"
curl -L -o $presto_download_name $presto_download_url
mkdir $decompressed_dir
tar xzf $presto_download_name -C $decompressed_dir

presto_dir=`\ls $decompressed_dir`
for file in `\ls $decompressed_dir/$presto_dir`; do
  mv $decompressed_dir/$presto_dir/$file $parcel_name
done
rm -rf $decompressed_dir

presto_cli_download_url="${presto.url.base}/presto-cli/${presto.version}/presto-cli-${presto.version}-executable.jar"
echo "[INFO] Download Presto-cli: $presto_cli_download_url"
curl -L -O $presto_cli_download_url
mv presto-cli-${presto.version}-executable.jar ${parcel_name}/bin/
chmod +x ${parcel_name}/bin/presto-cli-${presto.version}-executable.jar

cat <<"EOF" > ${parcel_name}/bin/presto
#!/usr/bin/env python

import os
import sys
import subprocess
from os.path import realpath, dirname

path = dirname(realpath(sys.argv[0]))
arg = ' '.join(sys.argv[1:])
cmd = "env PATH=\"%s/../jdk/bin:$PATH\" %s/presto-cli-${presto.version}-executable.jar %s" % (path, path, arg)

subprocess.call(cmd, shell=True)
EOF
chmod +x ${parcel_name}/bin/presto

cp -a ${project.build.outputDirectory}/meta ${parcel_name}
tar zcf ${parcel_name}.parcel ${parcel_name}/ --owner=root --group=root

mkdir repository
for i in el6 el7 sles11 lucid precise squeeze wheezy; do
  cp ${parcel_name}.parcel repository/${parcel_name}-${i}.parcel
done

cd repository
curl https://raw.githubusercontent.com/cloudera/cm_ext/master/make_manifest/make_manifest.py | python

popd
