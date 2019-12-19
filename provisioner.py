from typing import List
from threading import Thread
import subprocess
import logging


#
# Logging.
#


logging.basicConfig(format='%(levelname)-8s %(message)s')
log = logging.getLogger("provisioner")
log.setLevel(logging.DEBUG)


def pipe_to_logger(pipe, logger: logging.Logger, level: int):
    with pipe:
        for line in pipe.readline():
            logger.log(level, line)


#
# Shell commands execution.
#


def run(cmd: List[str]):
    log.info("Executing: {}".format(" ".join(cmd)))
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    Thread(target=pipe_to_logger, args=[p.stdout, log, logging.INFO]).start()
    Thread(target=pipe_to_logger, args=[p.stderr, log, logging.WARNING]).start()
    p.wait()
    if p.returncode != 0:
        raise Exception("Error: {}".format(p.returncode))


#
# Main
#


if __name__ == '__main__':
    run(["true"])
    run(["false"])
