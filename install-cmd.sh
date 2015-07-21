

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





#########################################################
########    k8s on docker for Quagga   ##################
#########################################################
cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/k8s-on-docker-Quagga/ && sh install-k8s-master.sh


cd && rm -fr ~/GetStartingKubernetes && git clone https://github.com/hushi55/GetStartingKubernetes.git ~/GetStartingKubernetes && cd ~/GetStartingKubernetes/k8s-on-docker-Quagga/ && sh install-k8s-slave.sh


 