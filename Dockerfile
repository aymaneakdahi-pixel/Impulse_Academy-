FROM python:3.11-slim

# Installer LibreOffice + polices
RUN apt-get update && apt-get install -y --no-install-recommends \
    libreoffice \
    libreoffice-impress \
    fonts-dejavu \
    fonts-liberation \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Dépendances Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Code source
COPY . .

# Dossiers nécessaires
RUN mkdir -p generated uploads static/css static/js

EXPOSE 10000

CMD gunicorn app:app --bind 0.0.0.0:${PORT:-10000} --workers 2 --timeout 120
