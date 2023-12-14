# Docker Laravel PHP

![Docker Image Version (latest semver)](https://img.shields.io/docker/v/owow/laravel-php?logo=docker)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/owow/laravel-php/latest?logo=docker)
![Docker Automated build](https://img.shields.io/docker/automated/owow/laravel-php?logo=docker)

A docker image that can be used to run Laravel applications.

## Automated builds

This repository is automatically built and pushed to Docker Hub using Docker Automated Builds.

You can set up your own automated builds by following the steps below.

1. Go to your repository in Docker Hub. If you don't have one yet, create one.
1. Open the `Builds` tab.
1. Add the repo from GitHub or Bitbucket.
1. Configure the build settings:
    1. `Autotest` will test the build (not deploy it) whenever you trigger the selected action.
    1. `Repository links` will trigger a build when one of the used base images (`FROM ...`) is updated.
    1. `Build rules` will determine when to build the image:
        1. You probably want to keep the `latest` tag when pushing to `main`/`master`.
        1. You can add a tag by regex, for example `^[\d.]+` to match `1.0.0` and `1.0.1-dev` (Click on `View example build rules` for more examples).
1. Now when you push to master on GitHub, it will automatically build and push the selected image to Docker Hub under the `latest` tag.
When you create a tag, it will build and push the selected image to Docker Hub under the tag that matches the regex output (capture group or whole tag).
1. You can also trigger a build manually by clicking `Trigger` on the `Builds` page
