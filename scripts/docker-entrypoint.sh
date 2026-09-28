#!/bin/bash
set -euo pipefail

MOODLE_ROOT=/var/www/html
DATA_ROOT=/var/moodledata
CONFIG_FILE="${MOODLE_ROOT}/config.php"

if [[ ! -f "${CONFIG_FILE}" ]]; then
  echo "Waiting for database..."
  until php -r "
    \$host = getenv('MOODLE_DATABASE_HOST') ?: 'mariadb';
    \$user = getenv('MOODLE_DATABASE_USER') ?: 'moodle';
    \$pass = getenv('MOODLE_DATABASE_PASSWORD') ?: 'moodlepass';
    \$db = getenv('MOODLE_DATABASE_NAME') ?: 'moodle';
    new mysqli(\$host, \$user, \$pass, \$db);
  " 2>/dev/null; do
    sleep 2
  done

  echo "Installing Moodle..."
  php "${MOODLE_ROOT}/admin/cli/install.php" \
    --non-interactive \
    --agree-license \
    --lang=en \
    --wwwroot="${MOODLE_WWWROOT:-http://localhost:8080}" \
    --dataroot="${DATA_ROOT}" \
    --dbtype=mariadb \
    --dbhost="${MOODLE_DATABASE_HOST:-mariadb}" \
    --dbname="${MOODLE_DATABASE_NAME:-moodle}" \
    --dbuser="${MOODLE_DATABASE_USER:-moodle}" \
    --dbpass="${MOODLE_DATABASE_PASSWORD:-moodlepass}" \
    --fullname="${MOODLE_SITE_NAME:-Moodle}" \
    --shortname="${MOODLE_SITE_NAME:-Moodle}" \
    --adminuser="${MOODLE_USERNAME:-admin}" \
    --adminpass="${MOODLE_PASSWORD:-Admin@2026Strong!}" \
    --adminemail="${MOODLE_EMAIL:-admin@example.com}"

  chown www-data:www-data "${CONFIG_FILE}"
  chmod 640 "${CONFIG_FILE}"
fi

exec docker-php-entrypoint apache2-foreground
