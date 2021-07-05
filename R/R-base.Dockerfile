# use Amazon Linux 2 as the base
FROM amazonlinux:2

# install base libraries
RUN yum install -y \
    which \
    make \
    file \
    tar \
    gzip \
    unzip \
    git \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    libtool \
    libcurl-devel \
    libicu-devel \
    openssl-devel \
    python3-devel \
    python3-pip \
    xz-devel \
    zlib-devel \
    bzip2-devel \
    libjpeg-turbo-devel \
    pcre2-devel \
    java-devel \
    perl \
    cairo-devel \
    libtiff-devel \
    libX11-devel \
    libXt-devel

# set time zone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# update Python libraries
RUN python3 -m pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U && \
    python3 -m pip install --upgrade wheel &&\
    python3 -m pip install numpy pandas --user

# set Rprofile
RUN echo -e "options(bitmapType = 'cairo', repos = c(CRAN = 'https://cran.rstudio.com/'))" > ~/.Rprofile

# set R Makevars
RUN mkdir ~/.R && \
    echo -e "\
PKG_CFLAGS+=\"-fopenmp\" \n\
PKG_CXXFLAGS+=\"-fopenmp\" \n\
PKG_LIBS+=\"-fopenmp\" \n\
" > ~/.R/Makevars

# download and install R
RUN mkdir -p ~/lib_downloads/R && \
    cd ~/lib_downloads/R && \
    curl -O --progress-bar https://cran.r-project.org/src/base/R-4/R-4.0.5.tar.gz && \
    tar zxvf R-4.0.5.tar.gz && \
    cd R-4.0.5 && \
    echo -e "\
MAKE=\"make -j2\" \n\
\n\
CFLAGS=\"-Wall -march=native -g -O3 -ffp-contract=fast\" \n\
CXXFLAGS=\"-Wall -march=native -g -O3 -ffp-contract=fast\" \n\
OBJCFLAGS=\"-Wall -march=native -g -O3\" \n\
F77FLAGS=\"-Wall -march=native -g -O3\" \n\
FCFLAGS=\$F77FLAGS \n\
FLAGS=\$F77FLAGS \n\
" > config.site

RUN cd ~/lib_downloads/R/R-4.0.5 && \
    ./configure --with-readline=no --with-x --with-cairo && \
    make -j2 && \
    make install

# cleanup
RUN yum clean all && \
    rm -rf /var/cache/yum
