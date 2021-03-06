#!/bin/bash

type nc >/dev/null 2>&1 || { echo >&2 "Netcat required but it's not installed.  Aborting."; exit 1; }
curl --version >/dev/null 2>&1 || { echo >&2 "Curl required but it's not installed.  Aborting."; exit 1; }
python -c 'import mako' 2>&1 || { echo >&2 "Python Mako required but it's not installed.  Aborting."; exit 1; }
python -c 'import jinja2' 2>&1 || { echo >&2 "Python Jinja2 required but it's not installed.  Aborting."; exit 1; }

webserver_log=$(mktemp)
webserver_banner="Exposed testing APIs:

http://localhost:15001/reflect/mako?inj=*
http://localhost:15001/reflect/jinja2?inj=*

Web server standard output and error are redirected to file
$webserver_log
"

# Run  webserver
function run_webserver()
{
    echo "$api_string"
    cd env_py_tests/
    mkdir tpl/ 2> /dev/null
    python webserver.py &> $webserver_log
    cd ..
}


if [[ "$1" == "--test" ]]; then
  echo 'Run web server and launch tests'
  run_webserver &

  # Wait until the port is open
  while ! echo exit | nc localhost 15001; do sleep 1; done
  # Launch python engines tests
  python -m unittest discover . 'test_py_*.py'
  # Shutdown python webserver
  curl http://localhost:15001/shutdown
else
  echo 'Starting web server. Press ctrl-C to quit. Run with --test to run automated tests.'
  run_webserver
fi
