# Open Runtimes Logs

A sidecar that serves a runtime's execution logs over HTTP, so the executor can collect them without mounting the runtime's log directory.

Runtimes write each execution's output to `<dir>/<id>_logs.log` and `<dir>/<id>_errors.log` and return the id in `x-open-runtimes-log-id`. This server runs in its own container beside the runtime, sharing that directory.

```
GET /logs/<id>?max=<bytes>
```

The response body is the logs file followed by the errors file. `x-open-runtimes-logs-length` says where the first ends. Both files are deleted. Each part is cut at `max+1` bytes, so the caller can tell a truncated file from one that fits. Symlinks, FIFOs and devices left in a file's place are deleted unread.

| Variable | Default | |
|---|---|---|
| `OPEN_RUNTIMES_LOGS_DIR` | `/mnt/logs` | Directory the runtime writes to |
| `OPEN_RUNTIMES_LOGS_PORT` | `3001` | Listen port |
| `OPEN_RUNTIMES_SECRET` | | When set, requests must send it in `x-open-runtimes-secret` |

Image: `openruntimes/logs`, built from scratch, runs as UID 65532, about 2.5 MB.
