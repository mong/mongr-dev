FROM codercom/code-server:4.92.2

WORKDIR /home/coder

USER root
# debian extras
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    r-base \
    r-base-dev \
    apt-utils \
    mariadb-client \
    netcat-openbsd \
    tzdata \
    sudo \
    pandoc \
    libcurl3-gnutls \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libxml2-dev \
    libssl-dev \
    libmariadb-dev \
    libharfbuzz-dev libfribidi-dev \
    libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev \
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

USER 1000

# Set norsk bokmaal as default system locale
ENV LC_ALL=nb_NO.UTF-8
ENV LANG=nb_NO.UTF-8
ENV R_LIBS_USER=/home/coder/R/library

RUN mkdir -p ${R_LIBS_USER} \
    && R -e "install.packages(c('devtools', 'languageserver', 'jsonlite'), lib = Sys.getenv('R_LIBS_USER'), repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/bullseye/latest'))" \
    && R -e "devtools::install_github(c('mong/imongr', 'mong/tmongr'), lib = '/home/coder/R/library')" \
    && code-server --install-extension reditorsupport.r --install-extension mechatroner.rainbow-csv

COPY settings.json ./.local/share/code-server/User/settings.json
