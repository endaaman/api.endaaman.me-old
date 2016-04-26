# api.endaaman.me
This is personal API service for @endaaman.

## Note
* This API recieves file upload. The files are save to `/var/uploaded/enda` of the machine
so that you should do `mkdir -p /var/uploaded/enda` before running this.

* Using MongoDB via `mongodb://localhost:27017/enda`
  * If there `$MONGO_HOST` env value, accesses via `mongodb://<MONGO_HOST>/enda`.
    when production, this runs in Docker container so set
    ```
    bind_ip = 0.0.0.0
    ```
    in `mongo.conf`.
