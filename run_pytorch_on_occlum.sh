#!/bin/bash
set -e

BLUE='\033[1;34m'
NC='\033[0m'

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd )"
python_dir="$script_dir/occlum_instance/image/opt/python-occlum"

mkdir -p $script_dir/occlum_instance/image/etc
mkdir -p $script_dir/occlum_instance/image/opt/occlum/glibc/lib
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > $script_dir/occlum_instance/image/etc/resolv.conf
echo -e "hosts:	files dns" > $script_dir/occlum_instance/image/etc/nsswitch.conf
cp /lib/x86_64-linux-gnu/{libnss_dns.so.2,libnss_files.so.2,libresolv.so.2} $script_dir/occlum_instance/image/opt/occlum/glibc/lib

cd occlum_instance && rm -rf image
copy_bom -f ../pytorch.yaml --root image --include-dir /opt/occlum/etc/template

if [ ! -d $python_dir ];then
    echo "Error: cannot stat '$python_dir' directory"
    exit 1
fi

new_json="$(jq '.resource_limits.user_space_size = "1MB" |
                .resource_limits.user_space_max_size = "6000MB" |
                .resource_limits.kernel_space_heap_size = "1MB" |
                .resource_limits.kernel_space_heap_max_size = "2560MB" |
                .resource_limits.max_num_of_threads = 640 |
                .env.default += ["PYTHONHOME=/opt/python-occlum"]' Occlum.json)" && \
echo "${new_json}" > Occlum.json
occlum build

# Run the python demo
echo -e "${BLUE}occlum run /bin/python3 resnet.py${NC}"
occlum run /bin/python3 resnet.py resnet50.pth
