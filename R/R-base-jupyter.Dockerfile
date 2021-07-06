# use r-base as the base
FROM r-base:latest

RUN pip3 install lxml numpy pandas scipy matplotlib Pillow jupyterlab

RUN R -e "install.packages(c('repr', 'IRdisplay', 'IRkernel'), type = 'source')"
RUN R -e "IRkernel::installspec(user = FALSE)"
