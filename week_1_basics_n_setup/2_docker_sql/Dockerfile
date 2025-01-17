FROM python:3.12


RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingesting_ny.py ingesting_ny.py

ENTRYPOINT ["python", "ingesting_ny.py"]



