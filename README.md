# Use PyTorch with Python and Occlum

This project demonstrates how Occlum enables _unmodified_ [PyTorch](https://pytorch.org/) programs running in SGX enclaves, on the basis of _unmodified_ [Python](https://www.python.org).

## Sample Code: ResNet
ResNet Image Recognition Demo

https://pytorch.org/hub/pytorch_vision_resnet/
## How to Run

This tutorial is written under the assumption that you have Docker installed and use Occlum in a Docker container.

Occlum is compatible with glibc-supported Python, we employ miniconda as python installation tool. You can import PyTorch packages using conda. Here, miniconda is automatically installed by install_python_with_conda.sh script, the required python and PyTorch packages for this project are also loaded by this script.

Suppose the project is under /opt/occlum-demo/pytorch

Step 0 (on the host): Download resnet50.pth to /opt/occlum-demo/pytorch

Step 1 (on the host): Start an Occlum container
```
docker run -it --privileged -v /dev/sgx:/dev/sgx -v /opt/occlum-demo:/opt/occlum-demo occlum/occlum:latest-ubuntu20.04
docker run -it --name=pythonDemo --device /dev/sgx/enclave occlum/occlum:0.29.3-ubuntu20.04 bash
```

Step 2 (in the Occlum container): Download miniconda and install python to prefix position.
```
cd /opt/occlum-demo/pytorch
bash ./install_python_with_conda.sh
```

Step 3 (in the Occlum container): Run the sample code on Occlum
```
cd /opt/occlum-demo/pytorch
bash ./run_pytorch_on_occlum.sh
```
