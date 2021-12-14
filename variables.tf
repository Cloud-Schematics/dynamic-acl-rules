##############################################################################
# ACL Variables
##############################################################################

variable prefix {
    description = "A unique identifier need to provision resources. Must begin with a letter"
    type        = string
    default     = "dynamic-acl-test"

    validation  {
      error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
      condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix))
    }
}

variable subnets {
  description = "List of subnets to create ACL rules for"
  type        = list(object({
      name           = string
      cidr           = string
  }))
  
  default = [
    {
      name = "test-subnet"
      cidr = "10.10.10.10/24"
    }
  ]
}

variable allow {
  description = "Allow or deny traffic for all subnets. True for `allow` false for `deny`."
  type        = bool
  default     = true
}


variable rule {
  description = "Rule to create for traffic to and from list of subnets. A rule will be created to allow traffic to and from the source. Optionally, this traffic can be `tcp`, `udp`, or `icmp`"
  type        = object({
    source = string
    tcp    = optional(
      object({
        port_max        = optional(number)
        port_min        = optional(number)
        source_port_max = optional(number)
        source_port_min = optional(number)
      })
    )
    udp         = optional(
      object({
        port_max        = optional(number)
        port_min        = optional(number)
        source_port_max = optional(number)
        source_port_min = optional(number)
      })
    )
    icmp        = optional(
      object({
        type = optional(number)
        code = optional(number)
      })
    )
  })

  default = {
    source = "0.0.0.0/0"
  }

  validation {
    error_message = "Can only contain one of `tcp`, `udp`, or `icmp` rule."
    condition     = length(
      [
        for type in ["tcp", "icmp", "udp"]:
        true if var.rule[type] != null
      ]
    ) <= 1
  }
}

##############################################################################