
# Upload CoreOS cloud-config to a s3 bucket; s3-cloudconfig-bootstrap script in user-data will download 
# the cloud-config upon reboot to configure the system. This avoids rebuilding machines when 
# changing cloud-config.
resource "aws_s3_bucket_object" "controller_cloud_config" {
  bucket = "${var.aws_account["id"]}-${var.cluster_name}-config"
  key = "controller/cloud-config.yaml"
  content = "${data.template_file.controller_cloud_config.rendered}"
}
data "template_file" "controller_cloud_config" {
    template = "${file("./artifacts/cloud-config.yaml.tmpl")}"
    vars {
        "CLUSTER_NAME" = "${var.cluster_name}"
        "CLUSTER_INTERNAL_ZONE" = "${var.cluster_internal_zone}"
        "ROUTE53_ZONE_NAME" = "${var.route53_zone_name}"
        "MODULE_NAME" = "${var.module_name}"
        "KUBE_CLUSTER_CIDR" = "${var.kube_cluster_cidr}"
        "KUBE_SERVICE_CIDR" = "${var.kube_service_cidr}"
        "KUBE_SERVICE_NODE_PORTS" = "${var.kube_service_node_ports}"
        "KUBE_API_DNSNAME" = "${var.kube_api_dnsname}"   
        "KUBE_API_SERVICE" = "${var.kube_api_service}"
        "KUBE_VERSION" = "${var.kube_version}"
    }
}

resource "aws_s3_bucket_object" "envvars" {
    bucket = "${var.aws_account["id"]}-${var.cluster_name}-config"
    key = "controller/envvars"
    content = "${data.template_file.envvars.rendered}"
}
data "template_file" "envvars" {
    template = "${file("./artifacts/upload-templates/envvars")}"
    vars {
        "CLUSTER_NAME" = "${var.cluster_name}"
        "CLUSTER_INTERNAL_ZONE" = "${var.cluster_internal_zone}"
        "MODULE_NAME" = "${var.module_name}"
        "ROUTE53_ZONE_NAME" = "${var.route53_zone_name}"
        "CLUSTER_INTERNAL_ZONE" = "${var.cluster_internal_zone}"
        "KUBE_VERSION" = "${var.kube_version}"
        "VAULT_RELEASE" = "${var.vault_release}"
    }
}
