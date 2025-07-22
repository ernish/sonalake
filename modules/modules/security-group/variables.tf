variable "name" { type = string }
variable "vpc_id" { type = string }
variable "allowed_ports" {
  type        = list(any)
  default     = []
  description = "List of allowed ingress ports"
}
variable "allowed_ip" {
  type        = list(any)
  default     = []
  description = "List of allowed ip."
}
variable "protocol" {
  type        = string
  default     = "tcp"
  description = "The protocol. If not icmp, tcp, udp, or all use the."
}
variable "description" {
  default = "Managed by SG module - Terraform"
  type = string
}