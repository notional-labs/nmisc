import flask
import requests_cache
from prometheus_client.parser import text_string_to_metric_families

session = requests_cache.CachedSession('my_cache', backend='memory', expire_after=5, stale_if_error=True)
app = flask.Flask(__name__)


@app.route('/get_ibc_status', methods=['GET'])
def get_ibc_status():
    # chain_id = flask.request.args.get('chain_id')
    # qsdelcheck_endpoint = flask.request.args.get('qsdelcheck_endpoint')
    # threshold = flask.request.args.get('threshold')
    # print("chain_id: " + chain_id)
    # print("qsdelcheck_endpoint: " + qsdelcheck_endpoint)
    # print("threshold: " + threshold)
    #
    # prometheus_request = session.get(qsdelcheck_endpoint)
    # str_res = prometheus_request.text
    # itr_metrics = text_string_to_metric_families(str_res)
    # val = find_metric(itr_metrics, "qsd_icq_historic_queue", chain_id)
    # print("value: ", val)
    #
    # try:
    #     if val is not None:
    #         if val < int(threshold):
    #             return 'value = {0} => healthy'.format(val), 200
    # except:
    #     print("Err")

    return "down", 500


def find_metric(itr_metrics, metric_name, chain_id):
    for family in itr_metrics:
        for sample in family.samples:
            # print("Name: {0} Labels: {1} Value: {2}".format(*sample))
            if sample.name == metric_name and (sample.labels["chain_id"] == chain_id):
                return sample.value


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
