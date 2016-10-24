import json
import os
import uuid

from ailoads.fmwk import scenario, requests

URL_SHAVAR_SERVER = os.getenv('URL_SHAVAR_SERVER',
                              "https://shavar.stage.mozaws.net/")
TIMEOUT = 30

_CONNECTIONS = {}


def get_connection(id=None):
    if id is None or id not in _CONNECTIONS:
        id = uuid.uuid4().hex
        conn = ShavarConnection(id)
        _CONNECTIONS[id] = conn

    return _CONNECTIONS[id]


class ShavarConnection(object):

    def __init__(self, id):
        self.id = id
        self.timeout = TIMEOUT

    def post(self, endpoint, data):
        return requests.post(
            URL_SHAVAR_SERVER + endpoint,
            data=json.dumps(data),
            timeout=self.timeout)

    def get(self, endpoint):
        return requests.get(
            URL_SHAVAR_SERVER + endpoint,
            timeout=self.timeout)

    def delete(self, endpoint):
        return requests.delete(
            URL_SHAVAR_SERVER + endpoint,
            timeout=self.timeout)


@scenario(1)
def get_lists():
    """Get TP lists from shavar server"""

    conn = get_connection('mozstd_track_digest256')
    data = {"body": "mozstd-track-digest256;a:1"}
    resp = conn.post(
        URL_SHAVAR_SERVER + '/downloads',
        data
    )
    body = resp.json()
    # assert "data" in body, "data not found in body"
    resp.raise_for_status()
