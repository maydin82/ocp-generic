backupdir=/root/
for etcd in $(oc get pod -n openshift-etcd --no-headers|grep -v $(hostname) | grep -o  '\S*etcd\S*' );
do
  etcd_host=$(oc exec ${etcd} -c etcdctl  -n openshift-etcd -- hostname)
  ssh   core@$etcd_host 'sudo -E rm ./assets/backup/*'
  ssh   core@$etcd_host 'sudo -E /usr/local/bin/cluster-backup.sh ./assets/backup'
  ssh   core@$etcd_host 'sudo -E chmod 644 ./assets/backup/*'
  scp   core@$etcd_host:/home/core/assets/backup/* $backupdir
  break
  # exit loop, only need 1 backup
done
