"""basic loadtest scenario(s) for shavar server
equivalent to calling black/white lists from shavar server:
$ curl -k  --data "mozstd-track-digest256;a:1" https://shavar.stage.mozaws.net/downloads # noqa"""
import os
import sys
from molotov import scenario

sys.path.append(".")
from lists_shavar import SHAVAR_LISTS as _LISTS


try:
    if os.environ['DEBUG'].lower() == 'true':
        DEBUG = True
except KeyError:
    DEBUG = False

try:
    URL_SERVER = os.environ['URL_SERVER']
except KeyError:
    print('ERROR: set URL_SERVER as env var ---> Aborting!')
    sys.exit(1)

_LINE = '------------------------------------------------------------'


def log_header(msg):
    print('\n\n{0}\n{1}\n{0}'.format(_LINE, msg))


@scenario(100)
async def get_all_lists(session):
    for list in _LISTS:
        """Get TP lists from shavar server"""

        data = '{0};a:1'.format(list)
        url = URL_SERVER + '/downloads'
        async with session.post(url, data=data) as resp:
            body = await resp.content.read()
            resp = str(body, 'utf8')
            if DEBUG:
                log_header(list)
                print(resp)
                
            """
            n:3600
            i:mozstd-trackwhite-digest256
            ad:1
            u:tracking-protection.stage.mozaws.net/mozstd-trackwhite-digest256/1478553365
            """
            
