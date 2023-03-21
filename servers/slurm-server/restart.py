
import os, time


SECONDS = 1
MINUTES = 60*SECONDS
wait = 5*MINUTES
command = './restart.sh'

while 1:

    os.system(command)
    time.sleep(wait)
