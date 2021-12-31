# Dynamic ACL Allow Rules

This module creates a list of ACL Rules for use with the `ibm_is_network_acl` terraform block. This module allows the creation of a rule to allow traffic to and from any source to a list of subnets. Optionally, this module create `deny` rules or rules for `tcp`, `udp`, or `icmp` traffic.

## Example Usage

```hcl-terraform
module dynamic_acl_rules {
  source  = "./dynamic_acl_rules
  prefix  = var.prefix
  subnets = var.subnets
}
```

### Creating Allow Rules For Subnet Tiers

This module allows you to easily create allow rules for different subnet ACL tiers within the same VPC

```hcl-terraform
# Example Subnets
locals {
  subnet_tiers = {
    # Subnets for tier 1
    subnet_tier_1 = [
      {
        name = "test-subnet-1"
        cidr = "10.10.0.10/24
      },
      {
        name = "test-subnet-2"
        cidr = "10.20.0.10/24
      }
    ]
    # Subnets for tier 2
    subnet_tier_2 = [
      {
        name = "test-subnet-1"
        cidr = "10.10.10.10/24
      },
      {
        name = "test-subnet-2"
        cidr = "10.20.10.10/24
      }
    ]
  }
}

module dynamic_acl_rules {
  source   = "./dynamic_acl_rules
  for_each = local.subnet_tiers
  prefix   = "${each.key}-allow"
  subnets  = each.value
}
```

This creates two `dynamic_acl_rules` modules `module.dynamic_acl_rules["subnet_tier_1"]` and `module.dynamic_acl_rules["subnet_tier_2"]`, each containing rules to allow all traffic to and from those subnets. Each of these rules lists can be referenced from the `rules` output.

#### Subnet Tier 1 Rules

Direction | Allow / Deny | Protocol | Source         | Source Port   | Destination    | Desination Port
----------|--------------|----------|----------------|---------------|----------------|-----------------
Inbound   | Allow        | All      | 10.10.0.0/0    | -             | 0.0.0.0/0      | -
Inbound   | Allow        | All      | 10.20.0.0/0    | -             | 0.0.0.0/0      | -
Outbound  | Allow        | All      | 0.0.0.0/0      | -             | 10.10.0.0/0    | -
Outbound  | Allow        | All      | 0.0.0.0/0      | -             | 10.20.0.0/0    | -

#### Subnet Tier 2 Rules

Direction | Allow / Deny | Protocol | Source         | Source Port   | Destination    | Desination Port
----------|--------------|----------|----------------|---------------|----------------|-----------------
Inbound   | Allow        | All      | 10.10.10.0/0   | -             | 0.0.0.0/0      | -
Inbound   | Allow        | All      | 10.20.10.0/0   | -             | 0.0.0.0/0      | -
Outbound  | Allow        | All      | 0.0.0.0/0      | -             | 10.10.10.0/0   | -
Outbound  | Allow        | All      | 0.0.0.0/0      | -             | 10.20.10.0/0   | -

## Module Variables

Name    | Description                                                                                                                                                                     | Type                                                                                                                                                                                                                                                                                                                                                                                                                               | Default
------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------
prefix  | A unique identifier need to provision resources. Must begin with a letter                                                                                                       | string                                                                                                                                                                                                                                                                                                                                                                                                                             | dynamic-acl-test
subnets | List of subnets to create ACL rules for                                                                                                                                         | list(object({ name = string cidr = string }))                                                                                                                                                                                                                                                                                                                                                                                      | [ { name = "test-subnet" cidr = "10.10.10.10/24" } ]
allow   | Allow or deny traffic for all subnets. True for `allow` false for `deny`.                                                                                                       | bool                                                                                                                                                                                                                                                                                                                                                                                                                               | true
rule    | Rule to create for traffic to and from list of subnets. A rule will be created to allow traffic to and from the source. Optionally, this traffic can be `tcp`, `udp`, or `icmp` | object({<br>source = string<br>tcp = optional(<br>object({<br>port_max = optional(number)<br>port_min = optional(number)<br>source_port_max = optional(number)<br>source_port_min = optional(number)<br>})<br>)<br>udp = optional( <br>object({<br>port_max = optional(number)<br>port_min = optional(number)<br>source_port_max = optional(number)<br>source_port_min = optional(number)<br>})<br>)<br>icmp = optional(<br>object({<br>type = optional(number)<br>code = optional(number)<br>})<br>)<br>}) | {<br>source = "0.0.0.0/0" <br>}

