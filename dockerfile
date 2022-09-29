FROM ubuntu:latest

RUN apt-get update && apt-get install -y software-properties-common && apt-get install -y cron vim && apt install -y cifs-utils
WORKDIR /app

# Add your application
COPY ./test.py /app/test.py

# Copy and enable your CRON task
#COPY ./mycron /app/mycron
RUN chmod 0644 /app/test.py
#RUN crontab /app/mycron
RUN crontab -l | { cat; echo "* * * * *  python3 /app/test.py >>/tmp/out.log 2>/tmp/err.log"; } | crontab -

# Create empty log (TAIL needs this)
RUN touch /tmp/out.log

# Start TAIL - as your always-on process (otherwise - container exits right after start)
CMD cron && tail -f /tmp/out.log
#RUN chmod 0644 /etc/cron.d/my-crontab
