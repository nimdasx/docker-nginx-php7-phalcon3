```

# docker nginx php-7.3 phalcon-3.4.5

# build dan push ke github
docker build --tag ghcr.io/nimdasx/nginx-php7-phalcon3 .
docker push ghcr.io/nimdasx/nginx-php7-phalcon3

# build dan push ke docker hub
docker build --tag nimdasx/nginx-php7-phalcon3 .
docker push nimdasx/nginx-php7-phalcon3

# pakai buildx
docker buildx build --platform linux/amd64 --tag nimdasx/nginx-php7-phalcon3 --push .

```

## Security & CI/CD
- **CVE-2026-109618 & CVE-2026-109619**: Patched via PHP 7.3 backport in `patches/` and `session.upload_progress.enabled = Off` in `php-nimdasx.ini`.
- **GitHub Actions**: Build otomatis via `.github/workflows/docker-build.yml` (push ke GHCR dan Docker Hub jika secret `DOCKERHUB_USERNAME` & `DOCKERHUB_TOKEN` di-set).
