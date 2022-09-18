# wordpress-lxd-terraform

Cette collection à pour but de configuer un serveur wordpress sur un noeud lxd   

Cette collection utilise :  
  * ansible  
  * terraform  
  * terraform-lxd  
  * lxd  
  * direnv  

## Requirements

Vous devez au minimum installer les paquets suivants :  
  * make  
  * direnv  
  * curl  
  * zip  

```
apt-get install -y make direnv curl zip 
if [ ! "$(grep -ir "direnv hook bash" ~/.bashrc)" ];then echo 'eval "$(direnv hook bash)"' >> ~/.bashrc; fi && direnv allow . && source ~/.bashrc
``` 

Cette collection utilise direnv en tant qu'environnement virtuel  

## Prepare environment

Pour préparer l'environnement et télécharger ressources nécessaires au bon fonctionnement de la collection :    

```
make install-python env
```

## Setup wordpress server  

Pour créer et configurer le serveur wordpress (wp-app, wp-bdd), vous avez juste à taper cette commande :  
```
make pprod-core-lxd  
```

Pour détruire le serveur wordpress :  
```
make pprod-core-lxd-destroy  
```

Après le déploiement, il ne vous reste plus qu'à rediriger le traffic internet entrant vers votre container  

## LXD REMOTE HOST REQUIREMENTS
Cette collection utilise le module remote LXD. Pour cela vous devez créer et configurer un serveur LXD qui utilise le remote access  
Le lien ci-dessous explique comment configurer cela :  
- https://stgraber.org/2016/04/12/lxd-2-0-remote-hosts-and-container-migration-612/  

Après l'installation de ce serveur, il ne vous reste plus qu'à configurer un fichier .env.local à la racine de ce dossier :  

```
export LXD_REMOTE_HOST_NAME=lxd_remote_host_42
export LXD_REMOTE_HOST_ADDRESS=user42
export LXD_REMOTE_HOST_PASSWORD=password42
```

## SSH ACCESS
Vous devez également configurer un accès ssh à votre host LXD.  
Ansible à besoin d'un accès ssh aux containers pour pouvoir les configurer. Les containers ne disposant pas d'adresse ip publique, j'utilise un rebond afin de pouvoir les atteindre :  

```
Host {{ project_workspace }}-lxd-host
  HostName {{ lxd_remote_ipv4 }}
  User lxd-user
  IdentityFile  {{ collection_root }}/secrets/lxd-host/id_ed25519

Host {{ project_workspace }}-wp-app
  Hostname {{ wp_app_ipv4 }}
  ProxyCommand ssh -F ssh.cfg -W %h:%p {{ project_workspace }}-lxd-host

Host {{ project_workspace }}-wp-bdd
  Hostname {{ wp_bdd_ipv4 }}
  ProxyCommand ssh -F ssh.cfg -W %h:%p {{ project_workspace }}-lxd-host

Host {{ project_workspace }}-*
  User {{ current_ssh_user }}
  IdentityFile  {{ ssh_private_key_file }}
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  ControlMaster   auto
  ControlPersist  15m
  ServerAliveInterval 100
  TCPKeepAlive yes

```

Votre clé ssh vers le noeud LXD doit se situer à la racine du projet :  
  * secrets/lxd-host/id_ed25519
