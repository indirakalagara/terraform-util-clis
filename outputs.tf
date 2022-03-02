output "bin_dir" {
  description = "Directory where the clis were downloaded"
  value       = local.bin_dir
  depends_on  = [data.external.setup-binaries]
}
