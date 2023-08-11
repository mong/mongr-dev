FROM rocker/verse:4.3.1

ARG GH_PAT
ENV GITHUB_PAT=${GH_PAT}

ENV DEBIAN_FRONTEND noninteractive

# debian extras
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    mariadb-client \
    netcat-openbsd \
    tzdata \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl3-gnutls \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libxml2-dev \
    libssl-dev \
    libmariadb-dev \
    texlive-base \
    texlive-binaries \
    texlive-pictures \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    lmodern \
    locales \
    locales-all \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set norsk bokmaal as default system locale
ENV LC_ALL=nb_NO.UTF-8
ENV LANG=nb_NO.UTF-8
RUN sed -i 's/^# *\(nb_NO.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && echo "LANG=\"nb_NO.UTF-8\"" > /etc/default/locale \
    && update-locale LANG=nb_NO.utf8

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
ARG IMONGR_DB_HOST_VERIFY=db-verify
ENV IMONGR_DB_HOST_VERIFY=${IMONGR_DB_HOST_VERIFY}
ARG IMONGR_DB_HOST_QA=db-qa
ENV IMONGR_DB_HOST_QA=${IMONGR_DB_HOST_QA}
ARG IMONGR_DB_NAME=imongr
ENV IMONGR_DB_NAME=${IMONGR_DB_NAME}
ARG IMONGR_DB_USER=imongr
ENV IMONGR_DB_USER=${IMONGR_DB_USER}
ARG IMONGR_DB_PASS=imongr
ENV IMONGR_DB_PASS=${IMONGR_DB_PASS}
ARG IMONGR_ADMINER_URL=http://localhost:8888
ENV IMONGR_ADMINER_URL=${IMONGR_ADMINER_URL}
ARG SHINYPROXY_USERNAME=imongr@mongr.no
ENV SHINYPROXY_USERNAME=${SHINYPROXY_USERNAME}
ARG SHINYPROXY_USERGROUPS=MANAGER,PROVIDER
ENV SHINYPROXY_USERGROUPS=${SHINYPROXY_USERGROUPS}

RUN touch /home/rstudio/.Renviron \
    && echo "TZ=${TZ}" > /home/rstudio/.Renviron \
    && echo "http_proxy=${PROXY}" >> /home/rstudio/.Renviron \
    && echo "https_proxy=${PROXY}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_CONTEXT=${IMONGR_CONTEXT}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_DB_HOST=${IMONGR_DB_HOST}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_DB_HOST_VERIFY=${IMONGR_DB_HOST_VERIFY}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_DB_HOST_QA=${IMONGR_DB_HOST_QA}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_DB_NAME=${IMONGR_DB_NAME}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_DB_USER=${IMONGR_DB_USER}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_DB_PASS=${IMONGR_DB_PASS}" >> /home/rstudio/.Renviron \
    && echo "IMONGR_ADMINER_URL=${IMONGR_ADMINER_URL}" >> /home/rstudio/.Renviron \
    && echo "SHINYPROXY_USERNAME=${SHINYPROXY_USERNAME}" >> /home/rstudio/.Renviron \
    && echo "SHINYPROXY_USERGROUPS=${SHINYPROXY_USERGROUPS}" >> /home/rstudio/.Renviron 


# add rstudio user to root group
ENV ROOT=TRUE

RUN R -e "remotes::install_github('mong/imongr')"
