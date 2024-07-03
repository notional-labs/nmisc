# ICQ Relayer HealthCheck

Used for uptime monitoring or Dashboard.

Porting code from `https://github.com/ingenuity-build/qsdelcheck/blob/main/check.py`

### APIs

There is only single api `get_icq_status`, usage:

```console
http://localhost:5001/get_icq_status?qsdelcheck_endpoint=http%3A%2F%2Fjoe.quicksilver.zone%3A9000%2F&chain_id=cosmoshub-4&threshold=5
```