# ibc_monitor

Used to monitor the last client of date all channels defined in a hermes config.

require to set `NOTIONAL_API_KEY` env var (https://notionalapi.com/).

### APIs

There is only single api `get_last_ibc_client_update`, usage:

```console
http://localhost:5001/get_last_ibc_client_update?hermes_config_url=https%3A%2F%2Fraw.githubusercontent.com%2Fnotional-labs%2Fcosmosia%2Fmain%2Frelaying%2Fcoreum_config.toml
```