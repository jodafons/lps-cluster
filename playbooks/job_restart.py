
import os, time


SECONDS = 1
MINUTES = 60*SECONDS
wait = 10*MINUTES
command = './restart_slurmd.sh'

while 1:

    os.system(command)
    time.sleep(wait)
