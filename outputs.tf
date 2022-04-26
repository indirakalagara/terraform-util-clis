output "bin_dir" {
  description = "Directory where the clis were downloaded"
  value       = data.external.setup-binaries.result.bin_dir
}
