FROM python:3.13.7
WORKDIR /app
COPY download.sh .
COPY requirements.txt .

RUN pip install -r requirements.txt
RUN apt update && apt install ffmpeg -y
# RUN apt install ffprobe

ENTRYPOINT ["./download.sh"]