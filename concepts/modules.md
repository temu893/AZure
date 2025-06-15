## Terraform Modules

**What is it?**  
A Terraform module is a container for multiple resources that are used together. It allows you to group resources and manage them as a single unit, promoting reusability and organization in your infrastructure code.

**How I implemented it:**  
I created a module for provisioning an Azure Virtual Network. The module is defined in its own directory with `main.tf`, `variables.tf`, and `outputs.tf` files. In my root configuration, I called the module as follows:

```hcl
module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = "my-resource-group"
  vnet_name           = "my-vnet"
  address_space       = ["10.0.0.0/16"]
}
```

**Why it matters:**  
Using modules helps to keep your Terraform code DRY (Don't Repeat Yourself) and makes it easier to manage complex infrastructures. It also allows for better collaboration, as different team members can work on different modules