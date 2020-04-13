FROM registry.access.redhat.com/ubi7/ubi

RUN yum upgrade -y && yum install -y git curl which openssl zip unzip && yum clean all -y \
  && curl -sL https://ibm.biz/idt-installer | bash \
  && export DESIRED_VERSION=v2.12.3 \
  && curl -sL https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash \
  && curl -s https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.3.5-202003041047.git.0.af13baf.el7/linux/oc.tar.gz | tar xz \
  && mv oc /usr/local/bin/oc

ARG user=b2biuser
ARG group=b2biuser
ARG uid=1010
ARG gid=1010
ARG NFS_HOME=/var/nfs-data
ENV NFS_HOME $NFS_HOME
RUN mkdir -p $NFS_HOME \
  && chown -R ${uid}:${gid} $NFS_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$NFS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}

ENTRYPOINT ["/bin/bash", "-ce", "tail -f /dev/null"]
