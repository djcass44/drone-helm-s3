# Drone Helm S3 Plugin

This plugin allows Drone to use the [helm-s3](https://github.com/hypnoglow/helm-s3) application to package and store charts in AWS S3.

*Note*: this project is not affiliated with the helm-s3 project, it simply uses it.

### Usage

```yaml
kind: pipeline
name: default

steps:
  - name: publish
    image: djcass44/drone-helm-s3:latest
    pull: always
    settings:
      aws_access_key:
        from_secret: AWS_ACCESS_KEY
      aws_secret_key:
        from_secret: AWS_SECRET_KEY
      aws_region: ap-southeast-2
      s3_bucket: <your bucket name>
      s3_path: <path to put charts (helm-s3 uses 'charts')>
      chart_name: <chart name>
      force: <true/false>
```

`aws_access_key`: (optional) should use IAM profile if not provided, however this has not been tested yet.

`aws_secret_key`: (optional)

`aws_session_token`: (optional)

`aws_region`: (optional)

`chart_name`: (required)

`force`: (optional) whether to overwrite the tarball if there is already an existing one.

#### TODO

* [ ] Add `context` to indicate that the chart is in a subdirectory

* [ ] Ensure IAM roles work

* [ ] Add option to re-index after a successful push