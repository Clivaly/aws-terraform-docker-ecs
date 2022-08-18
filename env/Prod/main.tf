module "prod" {
  source = "../../infra"

  repository_name = "prod"
}

output "IP_alb" {
  value = module.prod.IP
}