output "cluster_endpoint" {
  value = aws_eks_cluster.my_cluster.endpoint
  description = "The endpoint for the EKS cluster"
}

output "cluster_name" {
  value = aws_eks_cluster.my_cluster.name
  description = "The name of the EKS cluster"
}

