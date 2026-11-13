FROM rocker/verse:4.6.2

ENV DEBIAN_FRONTEND=noninteractive

# debian extras
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    locales \
    locales-all \
    default-mysql-client \
    netcat-openbsd \
    openssh-client \
    tzdata \
    libgit2-dev \
    sudo \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libmariadb-dev \
    libmariadb-dev-compat \
    libharfbuzz-dev \
    libfribidi-dev \
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

RUN --mount=type=secret,id=gh_pat,env=GH_TOKEN \
    R -e "install.packages(c('remotes', 'lifecycle', 'testthat', 'lintr'), repos='https://cloud.r-project.org/')" \
    && R -e "remotes::install_github(c('mong/imongr'), auth_token = if (nzchar(Sys.getenv('GH_TOKEN'))) Sys.getenv('GH_TOKEN') else NULL)"

COPY rstudio-prefs.json /home/rstudio/.config/rstudio/rstudio-prefs.json
