// Marked this as secret since I can't be sure what people are including in their Cloudformation outputs.
output stack_outputs {
  description = "A map of the final Outputs from the Cloudformation Stack"
  value       = aws_cloudformation_stack.outputs.outputs
  sensitive   = true
}