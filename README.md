1. Build:
   ```shell
   docker build -t greengagedb6_installed .
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
3. Make cluster:
   ```shell
   source gpdb_src/concourse/scripts/common.bash && make_cluster
   ```
4. Update pg_hba.conf:
   ```shell
   su - gpadmin -c '
   source /usr/local/greengage-db-devel/greengage_path.sh;
   source gpdb_src/gpAux/gpdemo/gpdemo-env.sh;
   echo "host    all    all    0.0.0.0/0    trust" >> "$MASTER_DATA_DIRECTORY/pg_hba.conf"'
   ```
5. Reload config:
   ```shell
   gpstop -u
   ```
6. Run the script against the container:
   ```shell
   psql -f script.sql -U gpadmin -d postgres -h 0.0.0.0 -p 6000
   ```
