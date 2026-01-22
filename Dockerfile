FROM freeradius/freeradius-server:latest

# Update apt package lists to allow installing new software
# We need Git to be able to clone the `freeradius-oauth2-perl` repository
# Required dependencies for running `freeradius-oauth2-perl`
# Enable additional modules, as needed
RUN apt-get update \
    && apt-get install -y git \
    && apt-get -y install --no-install-recommends ca-certificates curl libjson-pp-perl libwww-perl \
    && ln -s /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/ \
    && ln -s /etc/freeradius/mods-available/redis /etc/freeradius/mods-enabled/ \
    && git clone https://github.com/jimdigriz/freeradius-oauth2-perl.git /opt/freeradius-oauth2-perl/ \
    && printf '\n$INCLUDE /opt/freeradius-oauth2-perl/dictionary\n' >> /etc/freeradius/dictionary

COPY ./config/freeradius-oauth2-perl/ /opt/freeradius-oauth2-perl/
RUN ln -s /opt/freeradius-oauth2-perl/module /etc/freeradius/mods-enabled/oauth2 \
    && ln -s /opt/freeradius-oauth2-perl/policy /etc/freeradius/policy.d/oauth2

# Overwrite configuration files with our customized versions
COPY ./config/freeradius/ /etc/raddb
