terraform {
backend "s3" {
    bucket                      = "obs-1000035578-terraform-states"
    key                         = "vturok-bde48a77-0cf4-42c8-bc2d-0b37d198a0dc/terraform.tfstate"
    region                      = "eu-de"
    endpoint                    = "obs.eu-de.otc.t-systems.com"
    encrypt                     = false
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}
