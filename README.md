# Helm push action

This action package helm chart and publish it to your chartmuseum.

## Usage

### `workflow.yml` Example

Place in a `.yml` file such as this one in your `.github/workflows` folder. [Refer to the documentation on workflow YAML syntax here.](https://help.github.com/en/articles/workflow-syntax-for-github-actions)

```yaml
name: Build & Push ecs-exporter chart
on: push

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - uses: goodsmileduck/helm-push-action@v2
      env:
        SOURCE_DIR: '.'
        CHART_FOLDER: 'ecs-exporter'
        FORCE: 'True'
        SKIP_SECURE: 'False'
        CHARTMUSEUM_URL: 'https://chartmuseum.url'
        CHARTMUSEUM_USER: '${{ secrets.CHARTMUSEUM_USER }}'
        CHARTMUSEUM_PASSWORD: ${{ secrets.CHARTMUSEUM_PASSWORD }}
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `CHARTMUSEUM_USER` and `CHARTMUSEUM_PASSWORD`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository.

| Key | Value | Suggested Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `CHARTMUSEUM_URL` | Chartmuseum url | `env` | **Yes** |
| `CHARTMUSEUM_USER` | Username for chartmuseum  | `secret` | **Yes** |
| `CHARTMUSEUM_PASSWORD` | Password for chartmuseum | `secret` | **Yes** |
| `SKIP_SECURE` | Allowing to push using insecure connection | `env` | No |
| `SSL_CERTIFICATE_PATH` | Allowing to use custom SSL certificate | `env` | No |
| `SSL_CERTIFICATE_CA_PATH` | Allowing to use custom SSL certificate bundle | `env` | No |
| `SSL_CERTIFICATE_KEY_PATH` | Allowing to provide custom SSL key | `env` | No |
| `DEBUG` | add `--debug` flag to ChartMuseum push command | `env` | No |
| `FORCE` | Force chart upload (in case version exist in chartmuseum, upload will fail without `FORCE`). Defaults is `False` if not provided. | `env` | No |
| `SOURCE_DIR` | The local directory you wish to upload. If your chart is in nested folder, `SOURCE_DIR` should be the path from root to the last folder before the one that stores the chart. For example, if your chart is in `./charts/app`, the `SOURCE_DIR` is `./charts/`. Defaults to the root of your repository (`.`) if not provided. | `env` | No |
| `CHART_FOLDER` | Folder with charts in repo. This should be the name of the folder where the chart is in. For example, if your chart is in `./charts/app`, the `CHART_FOLDER` is `app` | `env` | **Yes** |

OBS.: Be aware that `SOURCE_DIR`+`CHART_FOLDER` should be the path of the directory where your `Chart.yaml` file is in.

## Action versions

- v2: helm v2.17.0
- v3: helm3 v3.7.2

## License

This project is distributed under the [MIT license](LICENSE.md).
