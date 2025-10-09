This demo cluster serves as a Greengage DBMS sandbox environment.
You can either use a prebuilt Greengage DB Docker image from [Docker Hub](https://hub.docker.com/u/greengagedb) or build a custom image from source.


## (Optional) Build a custom image

Build a Docker image as described in [Build a Greengage DB Docker image](https://greengagedb.org/en/docs-gg/current/use_docker.html).
Then, update the [Dockerfile](Dockerfile) to customize your image as needed.

For AArch64 systems, use the following command:
```shell
$ docker buildx build --platform=linux/amd64 -t greengagedb6:latest -f ci/Dockerfile.ubuntu .
```

## Start containers

1. Go to the project directory.
2. Build images and start cluster instances:
   ```shell
   $ docker compose build
   $ docker compose up
   ```


## Initialize a cluster

1. Connect to the master instance:
   ```shell
   $ docker exec -it mdw bash
   $ sudo su - gpadmin
   $ source .bashrc
   ```
2. Initialize a cluster as described here (starting with the **Enable passwordless SSH** section): [Initialize DBMS](https://greengagedb.org/en/docs-gg/current/initialize_dbms.html).
3. Edit _pg_hba.conf_ to allow local connections for all users and remote connections for `gpadmin`:
   ```shell
   $ echo "local   all    all      trust" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf"
   $ echo "host    all    gpadmin  0.0.0.0/0  trust" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf"
   ```
4. Apply the new configuration:
   ```shell
   $ gpstop -u
   ```


## Stop containers

1. Stop the cluster:
   ```shell
   $ gpstop
   ```
2. Stop containers:
   ```shell
   $ docker compose down
   ```
