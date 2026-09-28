FROM moodlehq/moodle-php-apache:8.3-bookworm

ARG MOODLE_BRANCH=MOODLE_502_STABLE

RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/www/html/* \
    && git clone --depth 1 --branch "${MOODLE_BRANCH}" https://github.com/moodle/moodle.git /var/www/html \
    && mkdir -p /var/moodledata \
    && chown -R www-data:www-data /var/www/html /var/moodledata

COPY scripts/docker-entrypoint.sh /usr/local/bin/moodle-entrypoint.sh
RUN chmod +x /usr/local/bin/moodle-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/moodle-entrypoint.sh"]
