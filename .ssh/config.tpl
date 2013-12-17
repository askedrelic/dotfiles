Host *
    ServerAliveInterval 60
    ServerAliveCountMax 10
    GSSAPIAuthentication no
    TCPKeepAlive no
    ControlMaster auto
    ControlPath ~/.ssh/%r@%h:%p
    ControlPersist 4h
