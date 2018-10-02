FROM python:3.7-alpine

RUN apk add --no-cache g++
RUN pip install pipenv

# Run commands as non root user
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser
WORKDIR /home/appuser

# Install dependencies
ADD Pipfile Pipfile
ADD Pipfile.lock Pipfile.lock

RUN pipenv sync

# Copy notebooks to image
ADD ./notebooks ./notebooks

CMD ["/bin/sh"]
