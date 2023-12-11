# IBC Relayer HealthCheck

Used for uptime monitoring or Dashboard

### APIs

There is only single api `get_ibc_status`, usage:

```console
http://localhost:5001/get_ibc_status?url=http%3A%2F%2Fapi-coreum-ia.cosmosia.notional.ventures%2F%2Fibc%2Fcore%2Fchannel%2Fv1%2Fchannels%2Fchannel-2%2Fports%2Ftransfer%2Fpacket_commitments&threshold=20
```