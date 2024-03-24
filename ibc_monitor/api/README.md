# ibc_monitor

Used to monitor the last client of date all channels defined in a hermes config.

require to set `NOTIONAL_API_KEY` env var (https://notionalapi.net/).

## APIs

There are 2 apis:

#### 1. get_last_ibc_client_update

usage:
```console
http://localhost:5001/get_last_ibc_client_update?hermes_config_url=https%3A%2F%2Fraw.githubusercontent.com%2Fnotional-labs%2Fcosmosia%2Fmain%2Frelaying%2Fcoreum_config.toml
```

#### 2. get_wallet_balance

usage:
```console
http://127.0.0.1:5001/get_wallet_balance?relayer_hub_name=coreum&process=main
```

each relayer hub has 2 processes: 
- main: hermes instanc for relaying 
- cron: to run a couple of cronjobs:
    - clear: to clear pending packets every 5 mins
    - update_client: to update client having last update longer than 12 hours

metrics: (change `coreum` to other relayer hub name)
- main: `https://grafana-relayer.notional.ventures/hermes_main/coreum/metrics`
- cron: `https://grafana-relayer.notional.ventures/hermes_cron/coreum/metrics`

