FROM greengagedb6:latest

RUN apt-get update && apt-get install -y vim && rm -rf /var/lib/apt/lists/*
RUN /bin/bash -c "ssh-keygen -A"
RUN /bin/bash -c "source gpdb_src/concourse/scripts/common.bash && install_and_configure_gpdb"
RUN /bin/bash -c "gpdb_src/concourse/scripts/setup_gpadmin_user.bash"
