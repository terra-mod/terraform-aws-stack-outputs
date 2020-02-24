/**
 * # Cloudformation Stack Outputs
 *
 * This module creates a Cloudformation Stack soley for the purpose of allowing Stack Outputs and cross Cloudformation
 * references. This is particularly useful when combining both Cloudformation (say, from Serverless Framework) and Terraform
 * in the same project.
 *
 * Since Cloudformation does not allow creating a stack with out atleast a single resource - to get around
 * this, we create a custom `NullResource` in the Stack that uses a falsey condition, effectively creating a no-op.
 *
 * **Note**: Since Cloudformation does not allow any non-alphanumeric characters in the names of the Outputs, this module
 * will force `snake_case` and `kebab-case` into `CamelCase`.
 *
 * **Note**: If you need to quote any values as part of your Outputs, where the output value could be mistaken for YAML
 * syntax, you must use single quotes.
 *
 * ### Usage
 *
 *      module cfn_outputs {
 *        source = "{source}"
 *
 *        outputs = {
 *          foo = "bar"
 *          baz = "buux"
 *        }
 *      }
 */

terraform {
  required_version = "~> 0.12"
}

locals {
  // This is a little gross, but allows us to pass in snake_case or kebab-case keys
  // and convert them to CamelCase, since Cloudformation does not allow hyphens or underscores.
  outputs = { for k, v in var.outputs : replace(title(replace(k, "/[\\-_]/", " ")), " ", "") => { Value = (v) } }

  // yamlencode wraps everything in quotes, which Cloudformation does not like, so we remove the quotes.
  cfn_template = replace(yamlencode({
    Conditions = {
      HasNot = "!Equals ['true', 'false']"
    }
    Resources = {
      NullResource = {
        Type = "Custom::NullResource"
        Condition = "HasNot"
      }
    }
    Outputs = local.outputs
  }), "\"", "")
}

/**
 * Create the Cloudformation Stack that will output our values.
 */
resource aws_cloudformation_stack outputs {
  name = var.name

  template_body = local.cfn_template
}