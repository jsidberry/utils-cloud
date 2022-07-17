import subprocess
from subprocess import PIPE, STDOUT
import sys

web_servers = ("nginx","apache","apache2")

for web_server in web_servers:
    try:
        retcode = subprocess.run(['systemctl', 'status', web_server], stdout=PIPE, stderr=STDOUT)
        if retcode.returncode == 0:
            print("web-server is " + web_server)
    except OSError as e:
        print("Execution failed:", e, file=sys.stderr)
