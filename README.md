# Empa Surfaces Demo

**Standalone demo of the Empa [surfaces app](https://github.com/cpignedoli/mc-empa-surfaces) from [Materials Cloud](https://jupyter.materialscloud.org).**

## Try it live

[![Binder](https://mybinder.org/badge.svg)](https://mybinder.org/v2/gh/oschuett/empa-surfaces-demo/master?urlpath=%2Fapps%2Fstart_demo.ipynb)

Click the binder badge to try it live without installing anything.

## Development

With the included [Dockerfile](./Dockerfile) a development environment can be quickly created:

1. Install [Docker](https://docs.docker.com/engine/installation/).
2. git clone this repository
3. `docker build --tag demo_dev ./`
4. `docker run --init -ti -p8888:8888 demo_dev`
5. Browse to `http://localhost:8888/apps/start_demo.ipynb`