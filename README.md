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

ako prve je potrebne vykopirovat na OTC kluce, aby sme sa tam realne potom vedeli aj dostat
na to sluzi file **` keypair.tf `**