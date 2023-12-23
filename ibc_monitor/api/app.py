import os

import datetime
import flask
import requests
import timeago
import toml

NOTIONAL_API_KEY = os.environ["NOTIONAL_API_KEY"]

# to figure out chain name on Cosmosia, if chain is not available on Cosmosia then put the external rpc and api
# endpoints to
map_chainid_to_name = {
    "axelar-dojo-1": "axelar",
    "coreum-mainnet-1": "coreum",
    "cosmoshub-4": "cosmoshub",
    "dydx-mainnet-1": "dydx",
    "evmos_9001-2": "evmos",
    "gravity-bridge-3": "gravitybridge",
    "kaiyo-1": "kujira",
    "kava_2222-10": "kava",
    # "laozi-mainnet": "bandchain",
    "laozi-mainnet": {
        "rpc": "http://rpc.laozi1.bandchain.org",
        "api": "https://laozi1.bandchain.org/api",
    },
    "noble-1": "noble",
    "osmosis-1": "osmosis",
    # "secret-4": "secret",
    "secret-4": {
        "rpc": "https://secretnetwork-rpc.lavenderfive.com",
        "api": "https://secretnetwork-api.lavenderfive.com",
    },
}

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
                    counter_chain_id = ""
                    res_channel["channel_id"] = channel_id

                    try:
                        url = ""
                        if type(chain_obj) == dict:
                            url = "{}/ibc/core/channel/v1/channels/{}/ports/transfer/client_state" \
                                .format(chain_obj["api"], channel_id)
                        else:
                            url = "https://a-{}--{}.gw.notionalapi.com" \
                                  "/ibc/core/channel/v1/channels/{}/ports/transfer/client_state" \
                                .format(chain_obj, NOTIONAL_API_KEY, channel_id)

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

