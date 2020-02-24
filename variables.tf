variable name {
  description = "The name of the Cloudformation Stack to create."
  type        = string
}

variable outputs {
  description = "A map of keys and values that should be Outputs of the Cloudformation Stack."
  type        = map(string)
}