output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "load_balancer_dns_name" {
  value = aws_lb.app_lb.dns_name
}
