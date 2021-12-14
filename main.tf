##############################################################################
# Use local variable to return CIDR blocks
##############################################################################


locals {
    # Rules to allow all traffic to and from edge VPC CIDR blocks
    allow_rules = flatten([
        # For each subnet in that zone
        for subnet in var.subnets:
        # Create an array with rules to allow traffic to and from that subnet
        [
            { 
                  name        = "${var.prefix}-${subnet.name}"
                  action      = var.allow == true ? true : false
                  direction   = "inbound"
                  destination = var.rule.source
                  source      = subnet.cidr
                  tcp         = var.rule.tcp 
                  udp         = var.rule.udp 
                  icmp        = var.rule.icmp
            },
            {
                  name        = "${var.prefix}-${subnet.name}"
                  action      = var.allow == true ? true : false
                  direction   = "outbound"
                  destination = subnet.cidr
                  source      = var.rule.source
                  tcp         = var.rule.tcp 
                  udp         = var.rule.udp 
                  icmp        = var.rule.icmp
            }
        ]
    ])

}

output rules {
    description = "List of allow rules"
    value       = local.allow_rules
}

##############################################################################