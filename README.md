# Docker Codex

Run the [OpenAI Codex CLI](https://developers.openai.com/codex/cli/) in a small Docker container. The image keeps the CLI and its Node.js runtime out of the host while mounting the current project so Codex can work on it.

## Requirements

- Docker
- An OpenAI account that can use Codex

## Quick start

Build the image from this repository:

```sh
docker build -t codex .
```

Before starting the container for the first time, create the persistent Codex configuration directory:

```sh
cd /path/to/your/project
mkdir -p .codex-cfg
```

`.codex-cfg` must exist before the first container start. On first use, complete the sign-in flow prompted by Codex. Its configuration, authentication state, and session data are stored in that directory, so they survive container removal. It is ignored by Git and can contain credentials—do not commit or share it.

Start Codex in the project you want it to edit.

At the first start, network bridge to the host is necessary for Codex to authenitcate.

```sh
# Run the container with proper permissions
docker run -it --rm \
    --name codex \
    --network host \
    --userns=host \
    -u $(id -u):$(id -g) \
    -v $(pwd):/workspace \
    -w /workspace \
    ghcr.io/antonyho/docker-codex
```

After the authentication has completed at the first start, network bridge is not necessary. You may use follow command to run the container without further authentication.

```sh
# Run the container with proper permissions
docker run -it --rm \
    --name codex \
    --userns=host \
    -u $(id -u):$(id -g) \
    -v $(pwd):/workspace \
    -w /workspace \
    ghcr.io/antonyho/docker-codex
```

## Image tags

Two variants are published to `ghcr.io/antonyho/docker-codex`:

| Base image | Tags |
| --- | --- |
| `node:current-slim` (default) | `latest`, `node`, `<version>`, `<version>-node` (e.g. `0.1.2`, `0.1`, `0`, `0.1.2-node`, `0.1-node`, `0-node`) |
| `ubuntu:26.04` | `ubuntu`, `<version>-ubuntu` (e.g. `0.1.2-ubuntu`, `0.1-ubuntu`, `0-ubuntu`) |

To build the Ubuntu variant locally:

```sh
docker build -f Dockerfile.ubuntu -t codex:ubuntu .
```

## Configuration

The Dockerfile accepts `CODEX_VERSION`, which defaults to `latest`:

```sh
docker build --build-arg CODEX_VERSION=0.0.0 -t docker-codex:0.0.0 .
```

Use a published Codex CLI version when reproducible builds matter. The container sets `CODEX_HOME=/workspace/.codex-cfg`; because `/workspace` is a bind mount, the configuration remains local to the project rather than being baked into the image.

## Security notes

Codex can read and modify every file mounted at `/workspace`. Run the container from only the directory you intend to expose, review its permissions mode before approving commands, and never mount your whole home directory or unrelated secret-bearing directories. This image needs network access for authentication and the Codex service.

## License

MIT. See [LICENSE](LICENSE).
