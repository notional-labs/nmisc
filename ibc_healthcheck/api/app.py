import flask
import requests

app = flask.Flask(__name__)


@app.route('/get_ibc_status', methods=['GET'])
def get_ibc_status():
    url = flask.request.args.get('url')
    threshold = flask.request.args.get('threshold')

    print("url: " + url)
    print("threshold: " + threshold)

    try:
        rpc_request = requests.get(url)
        rpc_request_json = rpc_request.json()
        total = rpc_request_json["pagination"]["total"]

        if int(total) < int(threshold):
            return 'total = {0} => healthy'.format(total), 200
    except (Exception,):
        print("Err")

    return "down", 500


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5001)
