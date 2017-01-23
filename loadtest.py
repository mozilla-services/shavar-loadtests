import os

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

WEIGHT = 100
# curl -k  --data "mozstd-track-digest256;a:1" https://shavar.stage.mozaws.net/downloads # noqa


def log_header(msg):
    print('{0}\n{1}\n{0}'.format(_LINE, msg))


@scenario(WEIGHT)
async def get_all_lists(session):
    for list in _LISTS:
        """Get TP lists from shavar server"""

        data = '{0};a:1'.format(list)
        url = URL_SERVER + '/downloads'
        async with session.post(url, data=data) as resp:
            if DEBUG:
                log_header(list)
                body = await resp.content.read()
                resp = str(body, 'utf8')
                print(resp)
