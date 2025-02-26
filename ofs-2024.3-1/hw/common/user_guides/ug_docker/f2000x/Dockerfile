#Copyright (c) 2023 Intel Corporation
FROM redhat/ubi8:8.2

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

ENV PLATFORM_REPO = ofs-f2000x-pl
ENV PLATFORM = f2000x
ENV WORK_DIR = work_dir

ENV OFS_RELEASE=release/ofs-2023.1-1
ENV OFS_TAG=ofs-2023.1-1

ENV OPAE_SDK_VERSION=2.5.0
ENV OPAE_SDK_TAG=2.5.0-3

ENV FIM_REPO     = github.com/OFS/ofs-f2000x-pl.git
ENV OPAE_REPO    = https://github.com/OFS/opae-sdk.git
ENV OFS_AFU_REPO = https://github.com/OPAE/ofs-platform-afu-bbb

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
ENV OFS_ROOTDIR=$IOFS_BUILD_ROOT/$PLATFORM_REPO
ENV WORKDIR=$OFS_ROOTDIR 
ENV VERDIR=$OFS_ROOTDIR/verification/$PLATFORM/common:$OFS_ROOTDIR/verification 
ENV OFS_PLATFORM_AFU_BBB=$IOFS_BUILD_ROOT/ofs-platform-afu-bbb 

ENV OPAE_SDK_REPO_BRANCH=release/$OPAE_SDK_VERSION
ENV OPAE_PLATFORM_ROOT=$OFS_ROOTDIR/$WORK_DIR/build_tree 

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

#RUN subscription-manager config --server.proxy_hostname=$http_proxy \
#&&  echo "proxy=$http_proxy" | tee -a /etc/dnf/dnf.conf

RUN subscription-manager register --username  $REDUSER --password $REDPASS --auto-attach \
&&  subscription-manager release --set=8.2 \
&&  dnf upgrade -y 

RUN subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms \
&&  dnf install -y  https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm 

RUN dnf install -y wget python3 python3-pip python3-devel \
    gdb sudo vim nano git gcc gcc-c++ make cmake libuuid-devel rpm-build systemd-devel nmap \
    python3-jsonschema json-c-devel tbb-devel rpmdevtools libcap-devel \
    python3-pyyaml hwloc-devel libedit-devel git kernel-headers kernel-devel \
    elfutils-libelf-devel ncurses-devel openssl-devel bison flex cli11-devel spdlog-devel hwloc uuid \
&&  python3 -m pip install --user jsonschema virtualenv pudb pyyaml --no-input \
&&  sudo pip3 uninstall setuptools -y  \
&&  sudo pip3 install Pybind11==2.10.0 --proxy $http_proxy --no-input \
&&  sudo pip3 install setuptools==59.6.0 --prefix=/usr --proxy $http_proxy --no-input \
&&  mkdir $IOFS_BUILD_ROOT

WORKDIR  $IOFS_BUILD_ROOT

RUN wget http://ftp.pbone.net/mirror/archive.fedoraproject.org/epel/8.4/Everything/x86_64/Packages/p/pybind11-devel-2.4.3-2.el8.x86_64.rpm \
&& wget http://ftp.pbone.net/mirror/archive.fedoraproject.org/epel/8.4/Everything/x86_64/Packages/p/python3-pybind11-2.4.3-2.el8.x86_64.rpm \
&& sudo dnf localinstall ./python3-pybind11-2.4.3-2.el8.x86_64.rpm ./pybind11-devel-2.4.3-2.el8.x86_64.rpm -y \
&& rm -rf $IOFS_BUILD_ROOT/*

WORKDIR  $IOFS_BUILD_ROOT
COPY ofs_extratool.sh $IOFS_BUILD_ROOT/


RUN chmod +x $IOFS_BUILD_ROOT/ofs_extratool.sh \
&&  git config --global credential.helper store \ 
&&  git clone --recurse-submodules  https://$GITUSER:$GITTOKEN@github.com/OFS/ofs-f2000x-pl.git \
&&  git clone https://github.com/OFS/opae-sdk.git \
&&  git clone https://github.com/OPAE/ofs-platform-afu-bbb \
&&  cd $IOFS_BUILD_ROOT/opae-sdk/ \
&&  git checkout tags/$OPAE_SDK_TAG \
&&  cd $IOFS_BUILD_ROOT/ofs-f2000x-pl \
&&  git checkout --recurse-submodules tags/$OFS_TAG \
&&  cd $IOFS_BUILD_ROOT/opae-sdk/packaging/opae/rpm \
&&  ./create fedora \
&&  rm -rf opae-*.src.rpm \
&&  sudo dnf localinstall -y opae*.rpm 


WORKDIR  $IOFS_BUILD_ROOT
