variable "token" {
 type        = string
 description = "API-Token"
 default     = "youshouldchangethis"
}

variable "pbx_instances" {
  description = "Create 3CX Instances for Disaster Recovery"
  type        = list(string)
  default     = ["3cx-test", "3CX-prod"]
}
