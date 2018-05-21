node default {
    # Test message
    notify { "O FQDN desta VM eh ${::networking['fqdn']}": }

    include ntp
}

node 'agent01.treeipe.com', 'agent02.treeipe.com' {
    # Test message
    notify { "O FQDN desta VM eh ${::networking['fqdn']}": }

    include ntp, docker
}
