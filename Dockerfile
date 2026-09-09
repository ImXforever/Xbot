FROM python:3.12-slim

ARG BUILD_ID=20260909v2
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

COPY requirements.txt .
# ffmpeg converts edge-tts mp3 → ogg/opus for real Telegram voice bubbles
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip && pip install -r requirements.txt

COPY *.py catalog.json ./
COPY front/ ./front/
COPY back/ ./back/
COPY llm/ ./llm/
COPY locales/ ./locales/
COPY data/ ./data/
RUN mkdir -p /app/data

# run.py = unified launcher (bot polling + webapp on $PORT in one process)
CMD ["python", "run.py"]

