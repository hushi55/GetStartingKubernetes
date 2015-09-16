

## minions install cmd


## docker flannel cdn

#########################################################
########      docker flannel cdn      ###################
#########################################################
cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/minion/ && sh install.sh



#########################################################
########     docker flannel not cdn   ###################
#########################################################
cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/minion/ && sh install_nodns.sh



#########################################################
########    k8s on docker for flannel  ##################
#########################################################
cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/k8s-on-docker-flannel/ && sh install-k8s-master.sh


cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/k8s-on-docker-flannel/ && sh install-k8s-slave.sh


cp ~/flannel-0.5.1/flanneld /usr/bin/
chmod +x /usr/bin/flanneld
chkconfig --add flannel
chmod +x /etc/init.d/flannel
service flannel start

cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/centos6/ && sh install.sh


#########################################################
########    k8s on docker for Quagga   ##################
#########################################################
cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/k8s-on-docker-Quagga/ && sh install-k8s-master.sh


cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/k8s-on-docker-Quagga/ && sh install-k8s-slave.sh


#########################################################
########    k8s on docker for product   ##################
#########################################################
cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/product/ && sh install-k8s-master.sh


cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/product/ && sh install-k8s-slave.sh


########################
## docker check config
########################


## k8s delete namespace
kubectl --namespace=kingdee-test23 delete rc,services -l version=v1

https://raw.githubusercontent.com/docker/docker/master/contrib/check-config.sh

########## kubectl config set
kubectl config set clusters.cluster.server=http://172.20.10.221:8080
kubectl config set contexts.context.cluster cluster
kubectl config set current-context context
 