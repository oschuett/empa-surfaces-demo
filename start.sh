#!/bin/bash -e

set -x

sudo service postgresql start

jupyter-notebook --ip=0.0.0.0                                            \
                 --no-browser                                            \
                 --NotebookApp.token=''                                  \
                 --NotebookApp.iopub_data_rate_limit=1000000000          \
                 --NotebookApp.default_url="/apps/apps/surfaces/nanoribbon/search.ipynb"

# EOF
