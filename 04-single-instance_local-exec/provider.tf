provider "openstack" {
  user_name        = "devops-terraform"
  password         = "Tah3dhug"
  user_domain_name = "OTC-EU-DE-00000000001000035578"
  tenant_id        = "54026885c74446c2b833f4dc7cb77bd2"
  auth_url         = "https://iam.eu-de.otc.t-systems.com:443/v3"
  region           = "eu-de"

  #version = "< 1.21.0"
}
