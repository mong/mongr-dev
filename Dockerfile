FROM rocker/verse:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LC_TIME nb_NO.UTF-8

# debian extras
RUN apt-get update && apt-get install -yq \
    apt-utils \
    locales \
    locales-all \
    mariadb-client \
    netcat-openbsd \
    tzdata \
    unixodbc \
    unixodbc-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# testing: shiny-server just do not get anything but locale C
RUN locale-gen nb_NO.UTF-8

# experimental add mariadb odbc driver not found in debian 9 repo...
ADD https://downloads.mariadb.com/Connectors/odbc/connector-odbc-2.0.15/mariadb-connector-odbc-2.0.15-ga-debian-x86_64.tar.gz /tmp
RUN tar xvzf /tmp/mariadb-connector-odbc-2.0.15-ga-debian-x86_64.tar.gz --directory /tmp
RUN cp /tmp/mariadb-connector-odbc-2.0.15-ga-debian-x86_64/lib/libmaodbc.so /usr/lib/x86_64-linux-gnu/odbc/
COPY --chown=rstudio:rstudio odbcinst.ini /etc/odbcinst.ini
COPY --chown=rstudio:rstudio odbc.ini /home/rstudio/.odbc.ini

# System locales
ENV LANG=nb_NO.UTF-8
ENV LC_ALL=nb_NO.UTF-8
RUN echo "LANG=\"nb_NO.UTF-8\"" > /etc/default/locale

# making env vars go all the way into Rstudio console, based on
# https://github.com/rocker-org/rocker-versioned/issues/91
ARG TZ=Europe/Oslo
ENV TZ=${TZ}
ARG PROXY=
ENV http_proxy=${PROXY}
ENV https_proxy=${PROXY}
ARG INSTANCE=DEV
ENV IMONGR_CONTEXT=${INSTANCE}
ARG IMONGR_DB_HOST=db
ENV IMONGR_DB_HOST=${IMONGR_DB_HOST}
ARG IMONGR_DB_NAME=imongr
ENV IMONGR_DB_NAME=${IMONGR_DB_NAME}
ARG IMONGR_DB_USER=imongr
ENV IMONGR_DB_USER=${IMONGR_DB_USER}
ARG IMONGR_DB_PASS=imongr
ENV IMONGR_DB_PASS=${IMONGR_DB_PASS}

RUN touch /home/rstudio/.Renviron
RUN echo "TZ=${TZ}" > /home/rstudio/.Renviron
RUN echo "http_proxy=${PROXY}" >> /home/rstudio/.Renviron
RUN echo "https_proxy=${PROXY}" >> /home/rstudio/.Renviron
RUN echo "IMONGR_CONTEXT=${IMONGR_CONTEXT}" >> /home/rstudio/.Renviron
RUN echo "IMONGR_DB_HOST=${IMONGR_DB_HOST}" >> /home/rstudio/.Renviron
RUN echo "IMONGR_DB_NAME=${IMONGR_DB_NAME}" >> /home/rstudio/.Renviron
RUN echo "IMONGR_DB_USER=${IMONGR_DB_USER}" >> /home/rstudio/.Renviron
RUN echo "IMONGR_DB_PASS=${IMONGR_DB_PASS}" >> /home/rstudio/.Renviron


# add rstudio user to root group  and optionally enable shiny server
ENV ROOT=TRUE
#RUN export ADD=shiny && bash /etc/cont-init.d/add

## provide user shiny with corresponding environmental settings
#RUN touch /home/shiny/.Renviron
#RUN echo "http_proxy=${PROXY}" >> /home/shiny/.Renviron
#RUN echo "https_proxy=${PROXY}" >> /home/shiny/.Renviron
#RUN echo "R_RAP_INSTANCE=${INSTANCE}" >> /home/shiny/.Renviron
#RUN echo "R_RAP_CONFIG_PATH=${CONFIG_PATH}" >> /home/shiny/.Renviron


# Install various packages
RUN R -e "install.packages(c('pool', 'RMariaDB'))"
RUN R -e "devtools::install_github('r-dbi/odbc')"
RUN R -e "remotes::install_github('mong/imongr')"


# Problem for shiny server: tinytex maybe not so fully automtaic...
#RUN usermod -a -G staff,rstudio shiny
#USER shiny
#RUN R -e "tinytex::tlmgr_install('collection-langeuropean')"
#USER root
