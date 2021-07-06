# use r-base as the base
FROM r-base:latest

RUN mkdir -p ~/shared_folder

RUN cd ~/lib_downloads && \
    curl --silent --location https://rpm.nodesource.com/setup_14.x | bash - && \
    yum -y install nodejs

RUN pip3 install lxml numpy pandas scipy matplotlib Pillow jupyterlab

RUN R -e "install.packages(c('repr', 'IRdisplay', 'IRkernel'), type = 'source')"
RUN R -e "IRkernel::installspec(user = FALSE)"
