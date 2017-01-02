sudo apt-get install build-essential git ipython ipython-notebook -y
cd ~
git clone https://github.com/BVLC/caffe.git
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev python python-dev python-scipy python-setuptools python-numpy python-pip libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler libatlas-dev libatlas-base-dev libatlas3-base libatlas-test -y
sudo apt-get install --no-install-recommends libboost-all-dev -y
sudo pip install --upgrade pip
sudo pip install --upgrade numpy
cd ~/caffe
cp Makefile.config.example Makefile.config
echo " If you're not using CUDA, then you'll want CPU only mode. Edit Makefile.config and uncomment LINE 08: CPU_ONLY := 1 LINE 50: BLAS_INCLUDE := /opt/intel/composer_xe_2011_sp1.10.319/mkl/include LINE 51: BLAS_LIB := /opt/intel/composer_xe_2011_sp1.10.319/mkl/lib/intel64. If your Linux OS version is superior than 15.10 then change at LINE 90: --- INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include WITH +++ INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial/"
gedit Makefile.config
echo "If your Linux OS version is superior than 15.10 then change LINE 181:--- LIBRARIES += glog gflags protobuf boost_system boost_filesystem m hdf5_hl hdf5 WITH LIBRARIES += glog gflags protobuf boost_system boost_filesystem m hdf5_serial_hl hdf5_serial"
gedit Makefile
make all -j$(nproc)
make test -j$(nproc)
make runtest -j$(nproc)
make pycaffe -j$(nproc)
cd ~
git clone https://github.com/google/deepdream.git
wget -P ~/caffe/models/bvlc_googlenet http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel
cd ~/deepdream
ipython notebook ./dream.ipynb
