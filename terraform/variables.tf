variable "connection_user" {
  description = "The user to connect to the remote host."
  type        = string
  sensitive   = true
}

variable "connection_host" {
  description = "The host or ip address to connect to the remote host."
  type        = string
  sensitive   = true
}

variable "connection_port" {
  description = "The port to connect to the remote host."
  type        = string
  sensitive   = true
}
variable "connection_private_keys" {
  description = "The private key to use for the connection."
  type        = string
  sensitive   = true
}
