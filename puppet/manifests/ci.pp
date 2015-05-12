class { 'java': }

class { 'firewall': }

firewall { '100 allow teamcity  access':
  port   => [8111],
  proto  => tcp,
  action => accept,
}
