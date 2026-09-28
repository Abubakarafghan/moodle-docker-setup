# Moodle Docker Setup

A simple Docker Compose setup for running Moodle locally with MariaDB. The first startup builds the Moodle container, waits for the database, and installs Moodle automatically.

## What is included

- Moodle served by Apache and PHP 8.3
- MariaDB 12.3 for the Moodle database
- Automatic first-time Moodle installation
- Persistent database and Moodle data directories
- Configuration through environment variables

## Requirements

Install the following software before starting:

- Docker Engine
- Docker Compose v2, available as `docker compose`
- Git, used during the Moodle image build

Linux users may need to add their account to the Docker group or run Docker commands with the permissions required by their system.

## Quick start

1. Clone the repository:

   ```bash
   git clone https://github.com/Abubakarafghan/moodle-docker-setup
   ```

2. Create your local environment file:

   ```bash
   cp .env.example .env
   ```

3. Change the passwords in `.env`. Do not commit `.env` to GitHub.

4. Build and start the services:

   ```bash
   docker compose up -d --build
   ```

5. Open Moodle in your browser:

   [http://localhost:8080](http://localhost:8080)

The administrator username, password, and email address are taken from `MOODLE_USERNAME`, `MOODLE_PASSWORD`, and `MOODLE_EMAIL` in `.env`.

## Configuration

The `.env.example` file contains the complete list of supported settings.

| Variable | Purpose | Example |
| --- | --- | --- |
| `MOODLE_BRANCH` | Moodle Git branch or tag to install | `MOODLE_502_STABLE` |
| `MOODLE_HTTP_PORT` | Local port exposed by Moodle | `8080` |
| `MOODLE_WWWROOT` | URL used by Moodle | `http://localhost:8080` |
| `MOODLE_USERNAME` | Initial administrator username | `admin` |
| `MOODLE_PASSWORD` | Initial administrator password | Change this immediately |
| `MOODLE_EMAIL` | Initial administrator email | `admin@example.com` |
| `MOODLE_SITE_NAME` | Moodle site name | `Moodle` |
| `MOODLE_DATABASE_HOST` | Database service name | `mariadb` |
| `MOODLE_DATABASE_NAME` | Database name | `moodle` |
| `MOODLE_DATABASE_USER` | Database user | `moodle` |
| `MOODLE_DATABASE_PASSWORD` | Database user password | Change this immediately |
| `MARIADB_ROOT_PASSWORD` | MariaDB root password | Change this immediately |
| `MARIADB_DATA_PATH` | Local database storage path | `./data/mariadb` |
| `MOODLE_DATA_PATH` | Local Moodle file storage path | `./data/moodledata` |

After changing `MOODLE_HTTP_PORT`, also update `MOODLE_WWWROOT` to use the same port.

## Useful commands

View service status:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f moodle
docker compose logs -f mariadb
```

Stop the services while keeping data:

```bash
docker compose down
```

Start the existing services again:

```bash
docker compose up -d
```

Rebuild the Moodle image after changing the Dockerfile or Moodle branch:

```bash
docker compose up -d --build
```

## Reset the local installation

To remove the containers and all local Moodle and database data, run:

```bash
docker compose down
rm -rf ./data/mariadb ./data/moodledata
docker compose up -d --build
```

This permanently deletes the local database, uploaded files, and site configuration. Create a backup before using this command.

## Data and backups

The following directories are intentionally local and should not be committed:

- `data/mariadb`: MariaDB database files
- `data/moodledata`: Moodle cache, configuration, uploaded files, and generated data

For a real deployment, back up both the database and `moodledata`. Test that backups can be restored before relying on them.

## Security

This project is intended for local development and demonstration by default. Before exposing it to the internet:

- Use strong, unique passwords in `.env`.
- Keep `.env`, database files, `moodledata`, and backups private.
- Put Moodle behind HTTPS with a properly configured reverse proxy.
- Use a supported Moodle release and update it regularly.
- Review Moodle's production deployment and security documentation.
- Do not use the example administrator credentials in a public or production installation.

The repository ignores `.env` and `data/`, but always verify `git status` before pushing to GitHub.

## How first installation works

When the Moodle container starts for the first time, `scripts/docker-entrypoint.sh`:

1. Waits until MariaDB accepts the configured credentials.
2. Runs Moodle's non-interactive CLI installer.
3. Creates `config.php` and applies the administrator settings from `.env`.
4. Starts Apache in the foreground.

On later starts, the existing `config.php` is reused and Moodle is not installed again.

## License

Moodle is free and open-source software distributed under the GNU General Public License v3 or later. Review Moodle's licensing requirements before redistributing Moodle or publishing modifications. Add a license file for the Docker setup itself if you add original code or documentation.

## Contributing

Issues and pull requests are welcome. Please avoid including passwords, private configuration, database exports, user information, or files from `data/` in contributions.