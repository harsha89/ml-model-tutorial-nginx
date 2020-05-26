FROM python:3.7

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         nginx \
    && rm -rf /var/lib/apt/lists/*
	
COPY conf/nginx.conf /etc/nginx/sites-enabled/default

WORKDIR /app

RUN pip install pandas scikit-learn flask uwsgi

ADD ./model ./model
ADD server.py server.py


CMD service nginx start && uwsgi -s /tmp/uwsgi.sock --chmod-socket=666 --manage-script-name --mount /=server:app
