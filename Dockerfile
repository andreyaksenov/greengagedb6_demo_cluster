FROM greengagedb6:latest

RUN /bin/bash -c "ssh-keygen -A"
RUN /bin/bash -c "source gpdb_src/concourse/scripts/common.bash && install_and_configure_gpdb"
RUN /bin/bash -c "gpdb_src/concourse/scripts/setup_gpadmin_user.bash"
