module "clis" {
  source = "./module"

  clis = ["yq", "jq", "igc", "helm", "argocd", "rosa", "gh", "glab", "kubeseal", "oc", "kubectl", "ibmcloud", "ibmcloud-is", "ibmcloud-ob", "ibmcloud-ks", "ibmcloud-cr", "kustomize", "gitu", "openshift-install-4.10.15"]
  
}

resource "null_resource" "write_path" {
  provisioner "local-exec" {
    #command = "echo -n '${module.clis.bin_dir}' > .bin_dir"
    command = "echo ${module.clis.bin_dir} > .bin_dir"
  }
}
