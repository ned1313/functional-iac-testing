output "lb_address_output" {
  description = "This output should be the Load Balancer's public IP address"
  
  value = module.webapp.lb_ip_address
}

output "lb_http_output" {
  description = "This output should be the http address"

  value = "http://${module.webapp.lb_ip_address}/"
}

output "terraform_state" {
  description = "This output is used as an attribute in the state_file control"

  value = "${path.cwd}/terraform.tfstate.d/${terraform.workspace}/terraform.tfstate"
}