module "prod" {
  source = "../../infra"

  repository_name = "production"
  officeIAM = "production"
  environment = "production"
}

output "IP_alb" {
  value = module.prod.IP
}