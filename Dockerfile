# This Dockerfile allows you to run python.cz website easily and without
# issues with dependencies - locally, on your server or in cloud like now.sh.
# That's handy for testing or for demonstration of new feature in a pull request.
#
# For running the website locally:
#
#     docker build -t python.cz .
#     docker run -p 8000:8000 python.cz
#
# ...and open in your browser: http://localhost:8000
#
# Environment variables can be specified too>
#
#     docker run -p 8000:8000 -e GITHUB_TOKEN=token123 python.cz

FROM python:3.9-alpine

RUN python3 -m pip install -U pip
RUN python3 -m pip install poetry
WORKDIR /app

# Install dependencies (to use `docker build` cache if they haven't changed)
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --with deployment 

COPY . ./
RUN poetry install

EXPOSE 8000

CMD [ \
  "poetry", "run", "gunicorn", \
  "--bind", "0.0.0.0:8000", \
  "--workers", "4", \
  "pythoncz:app" \
]
