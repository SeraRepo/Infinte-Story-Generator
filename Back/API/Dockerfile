
FROM python:3.9.12

RUN mkdir /api

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

RUN pip3 install torch --extra-index-url https://download.pytorch.org/whl/cu116

ADD . /api

WORKDIR /api

CMD [ "python3", "-u", "app.py"]