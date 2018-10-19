FROM python:3.7

# -- Install Pipenv:
RUN pip install pipenv

# Install requirements
COPY Pipfile /tmp/Pipfile
COPY Pipfile.lock /tmp/Pipfile.lock
RUN cd /tmp && pipenv install --deploy --system

# Set up user for mybinder
ARG NB_USER=appuser
ARG NB_UID=1000
RUN useradd -m -u ${NB_UID} -s /sbin/nologin ${NB_USER}

# USER ${NB_USER}
WORKDIR /home/${NB_USER}
USER ${NB_USER}

COPY scripts/entrypoint.sh entrypoint.sh

COPY ./notebooks ./notebooks

ENTRYPOINT [ "./entrypoint.sh" ]

CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
