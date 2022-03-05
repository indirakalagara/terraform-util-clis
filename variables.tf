variable "bin_dir" {
  type        = string
  description = "The directory where the clis should be downloaded. If not provided will default to ./bin"
  default     = ""
}

variable "clis" {
  type        = list(string)
  description = "The list of clis that should be made available in the bin directory. Supported values are yq, jq, igc, helm, argocd, rosa, gh, glab, and kubeseal. (If not provided the list will default to yq, jq, and igc)"
  #@enum: yq, jq, igc, helm, argocd, rosa, gh, glab, kubeseal, oc, kubectl, ibmcloud, ibmcloud-is
  default     = ["yq", "jq", "igc"]
}
