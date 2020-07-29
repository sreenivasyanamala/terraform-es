module "aws_es" {

  source = "./elastic-search"

  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config = {
    dedicated_master_enabled = "true"
    dedicated_master_type    = var.master_instance_type
    dedicated_master_count   = var.master_count
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    zone_awareness_enabled   = "true"
    availability_zone_count  = "3"
  }

  ebs_options = {
    ebs_enabled = "true"
    volume_size = var.volume_size
  }

  encrypt_at_rest = {
    enabled    = "true"
    kms_key_id = "alias/aws/es"
  }

  vpc_options = {
    subnet_ids         = ["var.subnetid_1", "var.subnetid_2"]
    security_group_ids = ["var.security_group_id"]
  }

  node_to_node_encryption_enabled                = true
  snapshot_options_automated_snapshot_start_hour = 23

  access_policies = templatefile("${path.module}/access_policies.tpl", {
    region      = data.aws_region.current.name,
    account     = data.aws_caller_identity.current.account_id,
    domain_name = var.domain_name
  })

  timeouts_update = "60m"

  tags = {
    Owner = "mohan"
    env   = "dev"
  }

}
