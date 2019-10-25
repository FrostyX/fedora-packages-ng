FROM fedora:30

# Disable modular repositories to save a running time of "dnf upgrade"
# if they exists.
RUN ls -1 /etc/yum.repos.d/*.repo
RUN sed -i '/^enabled=1$/ s/1/0/' /etc/yum.repos.d/*-modular.repo || true

RUN dnf -y upgrade \
  && dnf -y install \
  --setopt=tsflags=nodocs \
  # Required dependencies
  gcc \
  # For pg_config command required to install dependencies in
  # requirements.txt.
  libpq-devel \
  python3 \
  python3-devel \
  python3-humanize \
  python3-bodhi-client \
  js-html5shiv \
  js-jquery1 \
  js-respond \
  xstatic-bootstrap-scss-common \
  xstatic-datatables-common \
  xstatic-jquery-ui-common \
  xstatic-patternfly-common \
  # Development dependencies
  # For netcat (nc) command in entrypoint.sh.
  nmap-ncat \
  # tests
  python3-flake8 \
  && dnf clean all
RUN python3 --version
RUN python3 -m ensurepip \
  && python3 -m pip install --upgrade pip setuptools

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# add requirements
COPY ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip3 install -r requirements.txt

# add entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh

# add app
COPY . /usr/src/app

# run server
CMD ["./entrypoint.sh"]
