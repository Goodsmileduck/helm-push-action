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
        CHARTMUSEUM_URL: '${{ secrets.CHARTMUSEUM_URL }}'
        CHARTMUSEUM_URL_UNSTABLE: '${{ secrets.CHARTMUSEUM_URL_UNSTABLE }}'
        CHARTMUSEUM_USER: '${{ secrets.CHARTMUSEUM_USER }}'
        CHARTMUSEUM_PASSWORD: '${{ secrets.CHARTMUSEUM_PASSWORD }}'
        CHARTMUSEUM_REPO_NAME: '${{ secrets.CHARTMUSEUM_REPO_NAME }}'
        GIT_BRANCH_NAME: ${{ github.head_ref || github.ref_name }}
        GIT_STABLE_BRANCH_NAME: "main"
```

### Configuration

The following settings must be passed as environment variables as shown in the example. Sensitive information, especially `CHARTMUSEUM_USER` and `CHARTMUSEUM_PASSWORD`, should be [set as encrypted secrets](https://help.github.com/en/articles/virtual-environments-for-github-actions#creating-and-using-secrets-encrypted-variables) — otherwise, they'll be public to anyone browsing your repository.

| Key                        | Value                                                                                                                             | Suggested Type | Required |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------|----------------|----------|
| `CHART_FOLDER`             | Folder with charts in repo                                                                                                        | `env`          | **Yes**  |
| `CHARTMUSEUM_URL`          | stable chartmuseum repo url                                                                                                       | `env`          | **Yes**  |
| `CHARTMUSEUM_URL_UNSTABLE` | unstable chartmuseum repo url (pull request in progress for example)                                                              | `env`          | **Yes**  |
| `GIT_BRANCH_NAME`          | the git branch name where the update is triggering the github action (the push will be triggered on `CHARTMUSEUM_URL_UNSTABLE`)   | `env`          | **Yes**  |
| `GIT_STABLE_BRANCH_NAME`   | the git protected branch where the last stable version of the chart are pushed (the push will be triggered on `CHARTMUSEUM_URL`)  | `env`          | **Yes**  |
| `CHARTMUSEUM_REPO_NAME`    | helm chart name                                                                                                                   | `secret`       | **Yes**  |
| `CHARTMUSEUM_USER`         | Username for chartmuseum                                                                                                          | `secret`       | **Yes**  |
| `CHARTMUSEUM_PASSWORD`     | Password for chartmuseum                                                                                                          | `secret`       | **Yes**  |
| `SOURCE_DIR`               | The local directory you wish to upload. For example, `./charts`. Defaults to the root of your repository (`.`) if not provided.   | `env`          | No       |
| `FORCE`                    | Force chart upload (in case version exist in chartmuseum, upload will fail without `FORCE`). Defaults is `False` if not provided. | `env`          | No       |

## Action versions

- v2: helm v2.17.0
- v3: helm3 v3.7.2

## License

This project is distributed under the [MIT license](LICENSE.md).
