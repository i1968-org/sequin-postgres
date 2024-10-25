FROM goodrequestcom/postgis:16-3.4-postgresai4

# Install OpenSSL and sudo
RUN apt-get update && apt-get install -y openssl sudo

# Allow the postgres user to execute certain commands as root without a password
RUN echo "postgres ALL=(root) NOPASSWD: /usr/bin/mkdir, /bin/chown, /usr/bin/openssl" > /etc/sudoers.d/postgres

# Add init scripts while setting permissions
COPY --chmod=755 init-ssl.sh /docker-entrypoint-initdb.d/init-ssl.sh
COPY --chmod=755 wrapper.sh /usr/local/bin/wrapper.sh

# Configure PostgreSQL to load pg_cron on startup and set cron.database_name
RUN echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample \
    && echo "cron.database_name = 'railway'" >> /usr/share/postgresql/postgresql.conf.sample

ENTRYPOINT ["wrapper.sh"]
CMD ["postgres", "--port=5432"]
