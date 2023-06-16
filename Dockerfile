# Used R version 4.1.2
FROM rocker/r-ver:4.1.2

# Maintained by...
LABEL maintainer="Loren loren.wolfe@sagebase.org"

# Set Env variables
ENV RENV_PATHS_LIBRARY renv/library
ENV RENV_VERSION 0.17.3

# install libxml2
RUN apt-get update && apt-get -y \
    install libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libz-dev \
    libpng-dev

# copy files over
COPY . /data_flow_scheduled_job/

# set working directory
WORKDIR /data_flow_scheduled_job

# install a few packages
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# install R packages with renv
RUN R -e "renv::restore()"

# source and run update_manifest_script.R
CMD R -e "source('/data_flow_scheduled_job/update_dataflow_manifest.R')"