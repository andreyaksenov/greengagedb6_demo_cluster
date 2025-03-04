1. Build:
   ```shell
   docker build -t greengagedb6_installed .
   # or on ARM Mac
   docker buildx build --platform=linux/amd64 -t greengagedb6_installed .
   ```
2. Run:
   ```shell
   docker run \
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
4. Update _pg_hba.conf_ and reload the config:
   ```shell
   su - gpadmin -c '
   source /usr/local/greengage-db-devel/greengage_path.sh;
   source gpdb_src/gpAux/gpdemo/gpdemo-env.sh;
   echo "host    all    all    0.0.0.0/0    trust" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf";
   gpstop -u;'
   ```
5. Run the script against the container:
   ```shell
   psql -f script.sql -U gpadmin -d postgres -h 0.0.0.0 -p 6000
   ```
