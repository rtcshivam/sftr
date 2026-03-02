variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "context" {
  type = object({
    project     = string
    environment = string
    tags        = map(string)
  })
}
