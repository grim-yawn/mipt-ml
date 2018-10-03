FROM python:3.7

# -- Install Pipenv:
RUN pip install pipenv

# Install requirements
COPY Pipfile /tmp/Pipfile
COPY Pipfile.lock /tmp/Pipfile.lock
RUN set -ex && cd /tmp && pipenv install --deploy --system

# Set up user for mybinder
ENV NB_USER appuser
ENV NB_UID 1000
RUN adduser --disabled-password --uid ${NB_UID} ${NB_USER}

USER ${NB_USER}
WORKDIR /home/${NB_USER}

# Copy notebooks
COPY ./notebooks ./notebooks

CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
