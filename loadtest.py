import os
import uuid

from molotov.fmwk import scenario

URL_SERVER = os.getenv('URL_SERVER',
                       'https://shavar.stage.mozaws.net')
_CONNECTIONS = {}
TEST_ENV = 'STAGE'
TIMEOUT = 30
DEBUG = True 

_LINE = '---------------------------------'
_LISTS = [
    "base-track-digest256",
    "baseeff-track-digest256",
    "basew3c-track-digest256",
    "content-track-digest256",
    "contenteff-track-digest256",
    "contentw3c-track-digest256",
    "mozfull-track-digest256",
    "mozfullstaging-track-digest256",
    "mozplugin-block-digest256",
    "mozplugin2-block-digest256",
    "mozstd-track-digest256",
    "mozstd-trackwhite-digest256",
    "mozstdstaging-track-digest256",
    "mozstdstaging-trackwhite-digest256",
    "moztestpub-track-digest256",
    "moztestpub-trackwhite-digest256"
]

PERCENTAGE = 100
# curl -k  --data "mozstd-track-digest256;a:1" https://shavar.stage.mozaws.net/downloads # noqa


def log_header(msg):
    print('{0}\n{1}\n{0}'.format(_LINE, msg))


def get_connection(id=None):
    if id is None or id not in _CONNECTIONS:
        id = uuid.uuid4().hex
        conn = ShavarConnection(id)
        _CONNECTIONS[id] = conn

    return _CONNECTIONS[id]


@scenario(PERCENTAGE)
async def get_all_lists(session):
        for list in _LISTS:
        """Get TP lists from shavar server"""

        data = '{0};a:1'.format(list)
        #resp = conn.post('/downloads', data)
        #resp = await conn.post('/downloads', data)
        #data = 'mozfullstaging-track-digest256;a:1'
        url = URL_SERVER +'/downloads'
        #resp = await session.post(URL_SERVER + '/downloads', data) as res:
        async with session.post(url, data=data) as resp:
            if DEBUG:
                log_header(list)
                body = await resp.content.read()
                #body = await resp.text()
                resp = 'RESP: ' + str(body, 'utf8')
                print(resp)
