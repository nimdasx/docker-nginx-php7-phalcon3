# Changelog

## 2026-10-27
- **Security Mitigation (PHP2Shell)**: Disabled `session.upload_progress.enabled` in `php-nimdasx.ini` to mitigate unauthenticated OOM exploitation vectors (CVE-2026-109618 & CVE-2026-109619).
- **Core Security Patch**: Added backport patch `patches/php-7.3-CVE-2026-109618-109619.patch` for PHP 7.3 core (Zend bailout & request cleanup fixes).
- **Automated CI/CD**: Added GitHub Actions workflow (`.github/workflows/docker-build.yml`) to build and push the patched Docker image automatically to GHCR and Docker Hub (`nimdasx/nginx-php7-phalcon3:latest`).
