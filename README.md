# Cloudformation Stack Outputs

This module creates a Cloudformation Stack solely for the purpose of allowing Stack Outputs and cross Cloudformation references. This is particularly useful when combining both Cloudformation (say, from Serverless Framework) and Terraform in the same project.

Since Cloudformation does not allow creating a stack with out atleast a single resource - to get around  
this, we create a custom `NullResource` in the Stack that uses a falsey condition, effectively creating a no-op.

**Note**: Since Cloudformation does not allow any non-alphanumeric characters in the names of the Outputs, this module will force `snake_case` and `kebab-case` into `CamelCase`.

**Note**: If you need to quote any values as part of your Outputs, where the output value could be mistaken for YAML syntax, you must use single quotes.

### Usage

     module cfn_outputs {  
       source = "{source}"

       outputs = {  
         foo = "bar"  
         baz = "buux"  
       }  
     }
