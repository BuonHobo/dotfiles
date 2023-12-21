FROM alpine
RUN apk add py3-pip
RUN pip install discord.py requests --no-cache-dir --break-system-packages
WORKDIR /uscitibot
ENTRYPOINT python subscribot.py
