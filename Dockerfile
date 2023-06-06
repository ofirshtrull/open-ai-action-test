FROM python:3.11.3

ARG GITHUB_TOKEN

ENV PROJECT_HOME /app
ENV DJANGO_APP search_quality
ENV PORT 8080
ENV GUNICORN_THREADS=4
ENV GUNICORN_WORKERS=1
ENV USER appuser

WORKDIR ${PROJECT_HOME}

RUN groupadd -r ${USER} && useradd -r -g ${USER} ${USER}

COPY requirements.txt .

RUN git config --global url."https://${GITHUB_TOKEN}@github.com/".insteadOf "https://github.com/"
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY server ${PROJECT_HOME}

RUN chown -R ${USER}:${USER} ${PROJECT_HOME}

EXPOSE ${PORT}

USER ${USER}

CMD gunicorn ${DJANGO_APP}.wsgi:application \
    --bind 0.0.0.0:${PORT} \
    --workers ${GUNICORN_WORKERS} \
    --threads ${GUNICORN_THREADS}

