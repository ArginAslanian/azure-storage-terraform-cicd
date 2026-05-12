variable "admin_group_object_id" {
  description = "The Object ID of the Storage-Project-Admins group"
  type        = string
}

variable "reader_group_object_id" {
  description = "The Object ID of the Storage-Project-Readers group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "eastus"
}