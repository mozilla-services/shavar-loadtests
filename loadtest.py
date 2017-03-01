"""basic loadtest scenario(s) for shavar server
equivalent to calling black/white lists from shavar server:
$ curl -k  --data "mozstd-track-digest256;a:1" https://shavar.stage.mozaws.net/downloads # noqa
"""
import os
import sys
import random
from molotov import scenario

sys.path.append(".")
from lists_shavar import SHAVAR_LISTS as _LISTS     # noqa


try:
    URL_SERVER = os.environ['URL_SERVER']
except KeyError:
    print('ERROR: set URL_SERVER as env var ---> Aborting!')
    sys.exit(1)

ENDPOINT = URL_SERVER + '/downloads'


@scenario(100)
async def _get_list(session):
    data = '{0};a:1'.format(random.choice(_LISTS))
    async with session.post(ENDPOINT, data=data) as resp:
        assert resp.status == 200
