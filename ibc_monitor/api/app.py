import json
import os

import datetime
import flask
import requests
import timeago
import toml

NOTIONAL_API_KEY = os.environ["NOTIONAL_API_KEY"]

# to figure out chain name on Cosmosia, if chain is not available on Cosmosia then put the external rpc and api
# endpoints to
map_chainid_to_name = {}
with open("" + os.path.dirname(__file__) + "/map_chainid_to_name.json") as json_file:
    map_chainid_to_name = json.load(json_file)

app = flask.Flask(__name__)

def parseDate(strDate):
    stripped = "" + strDate.split('.', 1)[0] + "Z"
    dt = datetime.datetime.strptime(stripped, '%Y-%m-%dT%H:%M:%SZ')
    return dt


def get_block_time(chain_obj, block_num):
    url = ""
    if type(chain_obj) == dict:
        url = "{}/block?height={}" \
            .format(chain_obj["rpc"], block_num)
    else:
        url = "https://r-{}--{}.gw.notionalapi.com" \
              "/block?height={}".format(chain_obj, NOTIONAL_API_KEY, block_num)

    rpc_request = requests.get(url)
    rpc_request_json = rpc_request.json()

    block_time = ""

    # fix for sei
    if chain_obj == "sei":
        block_time = rpc_request_json["block"]["header"]["time"]
    else:
        block_time = rpc_request_json["result"]["block"]["header"]["time"]

    return block_time


@app.route('/get_last_ibc_client_update', methods=['GET'])
def get_ibc_status():
    hermes_config_url = flask.request.args.get('hermes_config_url')
    print("hermes_config_url: " + hermes_config_url)

    try:
        # url = "https://raw.githubusercontent.com/notional-labs/cosmosia/main/relaying/coreum_config.toml"
        rpc_request = requests.get(hermes_config_url)
        body = rpc_request.text
        parsed_toml = toml.loads(body)
        chains = parsed_toml["chains"]

        res = []

        for chain in chains:
            chain_id = chain["id"]
            chain_obj = map_chainid_to_name.get(chain_id)

            if chain_obj is not None:
                channels = chain["packet_filter"]["list"]
                for channel in channels:
                    res_channel = {
                        "chain_id": chain_id,
                    }
                    channel_id = channel[1]
                    res_channel["channel_id"] = channel_id
                    res_channel["client_id"] = ""
                    res_channel["latest_height"] = ""
                    res_channel["counter_chain_id"] = ""
                    res_channel["block_time"] = ""
                    res_channel["time_ago"] = ""
                    res_channel["pending_packets"] = -1

                    counter_chain_id = ""

                    try:
                        base_url = "https://a-{}--{}.gw.notionalapi.com".format(chain_obj, NOTIONAL_API_KEY)
                        if type(chain_obj) == dict:
                            base_url = chain_obj["api"]

                        url = "{}/ibc/core/channel/v1/channels/{}/ports/transfer/client_state".format(base_url, channel_id)
                        rpc_request = requests.get(url)
                        rpc_request_json = rpc_request.json()

                        client_id = rpc_request_json["identified_client_state"]["client_id"]
                        res_channel["client_id"] = client_id
                        latest_height = rpc_request_json["identified_client_state"]["client_state"]["latest_height"]["revision_height"]

                        res_channel["latest_height"] = latest_height
                        counter_chain_id = rpc_request_json["identified_client_state"]["client_state"]["chain_id"]

                        res_channel["counter_chain_id"] = counter_chain_id
                        counter_chain_obj = map_chainid_to_name.get(counter_chain_id)

                        block_time = get_block_time(counter_chain_obj, latest_height)
                        res_channel["block_time"] = block_time

                        timeagostr = timeago.format(parseDate(block_time), datetime.datetime.utcnow())
                        res_channel["time_ago"] = timeagostr

                        url = "{}/ibc/core/channel/v1/channels/{}/ports/transfer/packet_commitments".format(base_url, channel_id)
                        rpc_request = requests.get(url)
                        rpc_request_json = rpc_request.json()
                        pending_packets = int(rpc_request_json["pagination"]["total"])
                        res_channel["pending_packets"] = pending_packets

                        print("chain_id={}, client={}, channel_id={}, height={}, time={}, timeago={}"
                              .format(chain_id, counter_chain_id, channel_id, latest_height, block_time, timeagostr))

                    except (Exception,):
                        print("chain_id={}, client={}, channel_id={}, error"
                              .format(chain_id, counter_chain_id, channel_id))

                    res.append(res_channel)

        return res, 200
    except (Exception,):
        print("Err")

    return "error", 500


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)

