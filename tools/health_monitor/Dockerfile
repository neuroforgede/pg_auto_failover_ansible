FROM python:3.10

RUN apt-get update && apt-get install -y \
	python3-setuptools

RUN pip install --upgrade pip==21.2.4

WORKDIR /monitor

COPY . .

RUN chmod +x run.sh

RUN pip3 install -r requirements.txt

CMD ["/monitor/run.sh"]