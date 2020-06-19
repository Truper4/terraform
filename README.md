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
terraform init \
terraform plan -out=tfplan \
terraform apply "tfplan"
```