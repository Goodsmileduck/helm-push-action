# Helm push action
> **Note:** To use this action, you must have access to the [GitHub Actions](https://github.com/features/actions) feature. GitHub Actions are currently only available in public beta. You can [apply for the GitHub Actions beta here](https://github.com/features/actions/signup/).

This action uploads code to object storage and update Serverless funstion in Yandex cloud.

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
    - uses: goodsmileduck/helm-push-action@v0.1.1
      env:
        SOURCE_DIR: '.'
        CHART_FOLDER: 'ecs-exporter'
        CHARTMUSEUM_URL: 'https://chartmuseum.url'
        CHARTMUSEUM_USER: '${{ secrets.CHARTMUSEUM_USER }}'
        CHARTMUSEUM_PASSWORD: ${{ secrets.CHARTMUSEUM_PASSWORD }}
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `CHARTMUSEUM_USER` and `CHARTMUSEUM_PASSWORD`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository.

| Key | Value | Suggested Type | Required |
| ------------- | ------------- | ------------- | ------------- |
| `CHART_FOLDER` | Folder with charts in repo | `env` | **Yes** |
| `CHARTMUSEUM_URL` | Chartmuseum url | `env` | **Yes** |
| `CHARTMUSEUM_USER` | Username for chartmuseum  | `secret` | **Yes** |
| `CHARTMUSEUM_PASSWORD` | Password for chartmuseum | `secret` | **Yes** |
| `SOURCE_DIR` | The local directory you wish to upload. For example, `./charts`. Defaults to the root of your repository (`.`) if not provided. | `env` | No |


## License

This project is distributed under the [MIT license](LICENSE.md).
