FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install -y python3-dev  build-essential python-pip gunicorn
RUN pip install --upgrade setuptools
COPY src /app
WORKDIR /app
RUN pip install -r ./app/requirements.txt
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8000"]
