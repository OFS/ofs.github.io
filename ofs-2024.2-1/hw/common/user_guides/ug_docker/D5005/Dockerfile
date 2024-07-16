#Copyright (c) 2022 Intel Corporation
FROM redhat/ubi8:8.2

MAINTAINER Bolanos David Intel

ENV no_proxy= 
ENV http_proxy=
ENV https_proxy= 
ENV GITUSER=
ENV GITTOKEN= 
ENV REDUSER=
ENV REDPASS= 
ENV DW_LICENSE_FILE= 
ENV SNPSLMD_LICENSE_FILE=
ENV LM_LICENSE_FILE=

ENV OFS_RELEASE=d5005
ENV OFS_TAG=ofs-1.3.1

ENV OPAE_SDK_VERSION=2.1.1
ENV OPAE_SDK_TAG=2.1.1-1

ENV QUARTUS_MAINPATH=/home/intelFPGA_pro 
ENV QUARTUS_ROOTDIR=$QUARTUS_MAINPATH/quartus 
ENV QUARTUS_HOME=$QUARTUS_ROOTDIR 
ENV QUARTUS_INSTALL_DIR=$QUARTUS_ROOTDIR 
ENV QUARTUS_ROOTDIR_OVERRIDE=$QUARTUS_ROOTDIR 
ENV IMPORT_IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip 
ENV IP_ROOTDIR=$QUARTUS_ROOTDIR/../ip 
ENV INTELFPGAOCLSDKROOT=$QUARTUS_MAINPATH/hld 
ENV QSYS_ROOTDIR=$QUARTUS_ROOTDIR/../qsys/bin 
ENV IOFS_BUILD_ROOT=/home/IOFS_BUILD_ROOT 
ENV OFS_ROOTDIR=$IOFS_BUILD_ROOT/intel-ofs-fim 
ENV WORKDIR=$OFS_ROOTDIR 
ENV VERDIR=$OFS_ROOTDIR/verification/n6000/common:$OFS_ROOTDIR/verification 
ENV OFS_PLATFORM_AFU_BBB=$IOFS_BUILD_ROOT/ofs-platform-afu-bbb
ENV OPAE_SDK_REPO_BRANCH=release/$OPAE_SDK_VERSION
ENV OPAE_PLATFORM_ROOT=$OFS_ROOTDIR/work_d5005/build_tree    
ENV LIBRARY_PATH=$IOFS_BUILD_ROOT/opae-sdk/install-opae-sdk/lib 
ENV LD_LIBRARY_PATH=$IOFS_BUILD_ROOT/opae-sdk/install-opae-sdk/lib64 
ENV OPAE_LOC=/install-opae-sdk 
ENV PYTHONPATH=/root/.local/lib/python3.6/site-packages/ 
ENV QUARTUS_NUM_PARALLEL_PROCESSORS=8 
ENV python=/usr/bin/python3.6 
ENV python3=python3.6
ENV FPGA_BBB_CCI_SRC=$IOFS_BUILD_ROOT/intel-fpga-bbb 
ENV TOOLS_LOCATION=/home/guest 
ENV DESIGNWARE_HOME=$TOOLS_LOCATION/synopsys/vip_common/vip_Q-2020.03A 
ENV UVM_HOME=$TOOLS_LOCATION/synopsys/vcsmx/S-2021.09-SP1/linux64/rhel/etc/uvm 
ENV VCS_HOME=$TOOLS_LOCATION/synopsys/vcsmx/S-2021.09-SP1/linux64/rhel 
ENV MTI_HOME=$TOOLS_LOCATION/intelFPGA_pro/questa_fse 
ENV PATH=$PATH:$QUARTUS_HOME/bin:$QUARTUS_HOME/qsys/bin:$QUARTUS_HOME/sopc_builder/bin/:$IOFS_BUILD_ROOT/opae-sdk/install-opae-sdk/bin:$MTI_HOME/linux_x86_64/:$MTI_HOME/bin/:$DESIGNWARE_HOME/bin:$VCS_HOME/bin  

RUN subscription-manager register --username  $REDUSER --password $REDPASS --auto-attach \
&& dnf upgrade -y \
&& subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms \
&& dnf install -y python3-pip python3-devel gdb git gcc gcc-c++ make cmake rpm-build \
systemd-devel sudo nmap uuid python3-jsonschema json-c-devel tbb-devel rpmdevtools libcap-devel libedit-devel \
https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
autoconf automake bison boost boost-devel doxygen dwarves elfutils-libelf-devel \
flex hwloc-devel libarchive libedit libpcap libpng12 libuuid \
libuuid-devel libxml2 libxml2-devel ncurses ncurses-devel ncurses-libs openssl-devel \
libudev-devel pciutils grub2 bc csh flex elfutils-libelf-devel hwloc-devel nano \ 
python3-pyyaml glibc-locale-source libnsl \
&& pip3 install pybind11==2.10.0 setuptools==59.6.0 --prefix=/usr --no-input \
&& localedef -f UTF-8 -i en_US en_US.UTF-8 \
&& ln -s /usr/bin/python3 /usr/bin/python \
&& ln -s /usr/lib64/libncurses.so.6 /usr/lib64/libncurses.so.5 \
&& mkdir $IOFS_BUILD_ROOT \
&& dnf install -y spdlog-devel cli11-devel  python3-pybind11


### base 

WORKDIR  $IOFS_BUILD_ROOT
#insert help script 
COPY ofs_extratool.sh $IOFS_BUILD_ROOT/


RUN chmod +x $IOFS_BUILD_ROOT/ofs_extratool.sh \
&&  chmod +x $IOFS_BUILD_ROOT/ofs_n6000_eval.sh \
&&  git clone https://github.com/OPAE/opae-sdk.git \
&&  git clone https://$GITUSER:$GITTOKEN@github.com/otcshare/intel-ofs-fim.git \
&&  git clone https://github.com/OPAE/ofs-platform-afu-bbb \
&&  cd $IOFS_BUILD_ROOT/opae-sdk/ \
&&  git checkout tags/$OPAE_SDK_TAG -b release/$OPAE_SDK_VERSION \
&&  cd $IOFS_BUILD_ROOT/intel-ofs-fim \
&&  git checkout tags/$OFS_TAG -b release/$OFS_RELEASE \
&&  mkdir $IOFS_BUILD_ROOT/opae-sdk/install-opae-sdk \
&&  cd $IOFS_BUILD_ROOT/opae-sdk/install-opae-sdk \
&&  cmake .. -DCPACK_GENERATOR=RPM -DOPAE_BUILD_FPGABIST=ON -DOPAE_BUILD_PYTHON_DIST=ON -DCMAKE_BUILD_PREFIX=/install-opae-sdk \
&&  make -j `nproc` package_rpm \
&&  cd $IOFS_BUILD_ROOT/opae-sdk/install-opae-sdk \
&&  sudo dnf localinstall -y opae*.rpm


WORKDIR  $IOFS_BUILD_ROOT

