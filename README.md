# Terraform_training

veci ohladom terraformu, krok po kroku,... snad

vygenerovat na linux masine keypair id_rsa / id_rsa_pub, ten bude sluzit ako prihlasovanie z nasho stroja (bastionu)

```
mkdir .ssh && chmod 700 .ssh
vi ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

``` ssh-keygen -t rsa -b 4096 ``` \
``` ssh-copy-id -i ~/.ssh/tatu-key-ecdsa user@host ``` (ak by bolo treba kopirovat)

dalej je potrebne zabezpecit aby nam nic neblokovalo terraform (proxy), exportovali sme proxy nastavenia, snad to bude spravene
```
export http_proxy=http://10.14.38.3:3128
export https_proxy=http://10.14.38.3:3128
```

zakladne prikazy pre terraform \
``` terraform init ```         # inicializacia daneho priecinku, aby bol brany ako terraform priecinok
``` terraform plan -out=tfplan ``` \
``` terraform apply "tfplan" ``` \
``` terraform destroy -auto-approve ``` \
``` terraform state list ``` # zobrazi co mam "nainstalovane" terraformom

Ak budujeme prostredie, kde bude viac resourcov je dobre mat to co je spolocne pre vsetko v jednom terraform priecinku, nas pripad **`00-tenant-base`** obsahuje vsetky info o OTC clustri na ktorom buildujeme.

```
|-00-tenant-base
| |-keypair.tf
| |-provider.tf
| |-security-groups.tf
| |-sg-ssh.tf
```

ako prve je potrebne vykopirovat na OTC kluce, aby sme sa tam realne potom vedeli aj dostat, na to sluzi file **` keypair.tf `** \
dalej zakladne info o clustri je vo fajle **` provider.tf `** \
no a v neposlednom rade zadefinovat security groupy a ich role(y) \
nova sec grope je **` security-groups.tf `** a definicia roles je v **` sg-ssh.tf `**, je to nieco ako firewall rules.

vojdem do priecinka **`00-tenant-base`** a spustim seriu prikazov aby som spominane services "nainstaloval" a vedel ich pouzit do dalsieho buildu.
```
terraform init
terraform plan -out=tfplan
terraform apply "tfplan"
```
overim si co mi vybuildovalo cez ``` terraform state list ```
```
pmalatin@bastion3.novalocal:/home/pmalatin/TAC/00-tenant-base $ terraform state list
openstack_compute_keypair_v2.pmalatin-keypair
openstack_networking_secgroup_rule_v2.allow_ssh_pmalatin
openstack_networking_secgroup_rule_v2.outbound_ssh_pmalatin
openstack_networking_secgroup_v2.sg-ssh-pmalatin
```

Teraz sa mozeme pustit do buildu single instance **`01-single-instance`**
```
|-01-single-instance
| |-instance.tf
| |-locals.tf
| |-mount_vm.sh
| |-provider.tf
```
**` provider.tf `** je prekopirovany z **`00-tenant-base`** \
**` mount_vm.sh `** je len script ktory sa spusti po vybuildovani resourcu a mountne nam novy filesystem \
**` locals.tf `** zadefinovane locals ktore su dalej pouzite v **` instance.tf `** nieco ako premenne \
**` instance.tf `** main subor ktory ma zadefinovane vsetko pre build nasho resource

vojdem do priecinka **`01-single-instance`** a spustim seriu prikazov aby som buildol nas resource.
```
terraform init
terraform plan -out=tfplan
terraform apply "tfplan"
```
overim si co mi vybuildovalo cez ``` terraform state list ```
```
pmalatin@bastion3.novalocal:/home/pmalatin/TAC/01-single-instance $ terraform state list
data.openstack_compute_keypair_v2.pmalatin-keypair
data.openstack_networking_secgroup_v2.sg-AgileAcademyTelIT-default
data.openstack_networking_secgroup_v2.sg-ssh-pmalatin
openstack_blockstorage_volume_v2.data0
openstack_compute_instance_v2.pmalatin-vm
openstack_compute_volume_attach_v2.data0
openstack_networking_port_v2.primary_port
```
otestujem si ci masinu buildlo cez ssh, mala by byt dostupna na IP ktoru sme dali do **` locals.tf `** a user *linux*
```
pmalatin@bastion3.novalocal:/home/pmalatin/TAC/01-single-instance $ ssh linux@10.14.253.52
Warning: Permanently added '10.14.253.52' (ECDSA) to the list of known hosts.
Last login: Fri Jun 19 13:32:20 2020 from qdeqw7.de.t-internal.com
###################################################################
#   Important !!!                                                 #
#   Please change password for user linux after first login.      #
###################################################################
Adapt your keyboard map with sudo loadkeys de/us/... to match yours

[linux@pmalatin-vm ~]$
```
vidim ze ma pripojilo, je to pecka supa mega bomba a som **STASTNY**