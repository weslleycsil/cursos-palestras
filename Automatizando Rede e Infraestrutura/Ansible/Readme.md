# Começando com Ansible

Ansible é uma ferramenta de automação de TI de código aberto que permite aos administradores de rede automatizar tarefas de configuração, implantação e orquestração em infraestruturas de TI. Ele utiliza uma abordagem baseada em YAML para definir "playbooks" que descrevem os estados desejados dos sistemas e as tarefas necessárias para alcançá-los.

O Ansible é conhecido por sua simplicidade, facilidade de uso e capacidade de lidar com ambientes complexos de TI de forma eficiente. Ele utiliza comunicação SSH para se conectar aos sistemas remotos e não requer agentes instalados nos hosts alvo, tornando-o uma escolha popular para automação de infraestrutura.


- Agentless
- Só instalar e já sair usando
- Estrutura de Playbooks com YAML
- Eficiente
- Open Source

## Instalação

Instalação no Ubuntu 22.04

```
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible paramiko
```

## Comandos AD-HOC

```
ansible switches -m ping -i hosts
ansible routers -m ping -i hosts
ansible -i hosts -m vyos_facts routers
ansible -i hosts -m ios_facts switches
ansible -i hosts -m vyos.vyos.vyos_command -a 'commands="ping 8.8.8.8 count 5"' routers
```

```
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 -oHostKeyAlgorithms=+ssh-rsa cisco@10.20.100.2
```

/etc/ssh/ssh_config
```
HostKeyAlgorithms = +ssh-rsa
KexAlgorithms = +diffie-hellman-group1-sha1
```

## Playboks

- https://github.com/sergkondr-ansible/eve_images
- https://willgrana.com/posts/network-automation-lab-setup/
- https://github.com/rogerperkin/network-programmability
- https://yetiops.net/posts/ansible-for-networking-series/

https://docs.vyos.io/en/equuleus/automation/vyos-ansible.html