import flask
import os
import requests_cache
import requests
# from prometheus_client.parser import text_string_to_metric_families

session = requests_cache.CachedSession('my_cache', backend='memory', expire_after=5, stale_if_error=True)
app = flask.Flask(__name__)

NOTIONAL_API_KEY = os.environ["NOTIONAL_API_KEY"]


@app.route('/get_icq_status', methods=['GET'])
def get_icq_status():
    try:
        chain_id = flask.request.args.get('chain_id')
        str_url = ("https://a-quicksilver--{}.gw.notionalapi.net/quicksilver/interchainquery/v1/queries/{}").format(NOTIONAL_API_KEY, chain_id)
        icq_requests = requests.get(str_url)
        resp = icq_requests.json()
        val = resp['pagination']['total']
        icq_historic_queue = int(val)

        threshold = flask.request.args.get('threshold')
        print("chain_id: " + chain_id)
        print("threshold: " + threshold)
        print("value: ", val)

        if icq_historic_queue is not None:
            if icq_historic_queue < int(threshold):
                return 'value = {0} => healthy'.format(icq_historic_queue), 200
    except Exception as error:
        print("Err", error)

    return "down", 500


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
