FROM rocker/verse:4.3.3

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

# add rstudio user to root group
ENV ROOT=TRUE

RUN R -e "install.packages(c('lintr'))" \
    && R -e "remotes::install_github(c('mong/imongr', 'mong/tmongr'))"
