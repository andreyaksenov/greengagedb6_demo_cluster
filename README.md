1. Build an image with the installed Greengage DB:
   ```shell
   docker build -t greengagedb6_installed .
   # or on ARM Mac
   docker buildx build --platform=linux/amd64 -t greengagedb6_installed .
   ```
2. Run a container from the created image:
   ```shell
   docker run --hostname sample-ggdb-host \
     --name greengagedb6_demo \
     --rm \
     -it \
     --sysctl 'kernel.sem=500 1024000 200 4096' \
     -p 6000:6000 \
     greengagedb6_installed:latest \
     bash -c "ssh-keygen -A && /usr/sbin/sshd && bash"
   ```
3. Make the cluster:
   ```shell
   source gpdb_src/concourse/scripts/common.bash && make_cluster
   ```
4. Update _pg_hba.conf_ and stop the cluster:
   ```shell
   su - gpadmin -c '
   source /usr/local/greengage-db-devel/greengage_path.sh;
   source gpdb_src/gpAux/gpdemo/gpdemo-env.sh;
   echo "local   all    all    trust" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf";
   echo "host    all    all    0.0.0.0/0    trust" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf";
   gpstop -ra;'
   ```
5. Create a new image from the running container using `docker commit`:
   ```shell
   docker commit greengagedb6_demo greengagedb6_prepared:latest
   ```
6. Stop the `greengagedb6_demo` container.
7. Run a container from the `greengagedb6_prepared` image:
   ```shell
   docker run --hostname sample-ggdb-host \
     --name greengagedb6_demo \
     --rm \
     -it \
     --sysctl 'kernel.sem=500 1024000 200 4096' \
     -p 6000:6000 \
     greengagedb6_prepared:latest \
     bash -c "/usr/sbin/sshd && su - gpadmin -c '
     source /usr/local/greengage-db-devel/greengage_path.sh;
     source gpdb_src/gpAux/gpdemo/gpdemo-env.sh;
     gpstart -a; exec bash'"
   ```
8. Run a test script against the container:
   ```shell
   psql -f script.sql -U gpadmin -d postgres -h 0.0.0.0 -p 6000
   ```
