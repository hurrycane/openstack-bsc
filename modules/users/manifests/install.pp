class users::install {
    # Create wheel group
    group { "wheel":
        ensure => present,
        gid     => 901,
    }

    # Create users
    create_user { "bogdan":
        uid     => 1001,
        email   => "bogdan.gaza@yahoo.com",
        keyfiles => [ "bogdan.pub"]
    }

    # Put pubkey files in place
    define user_keys {
        $key_content = file("/etc/puppet/modules/users/files/$name", "/dev/null")
        if ! $key_content {
            notify { "Public key file $name not found on keymaster; skipping ensure => present": }
        } else {
            if $key_content !~ /^(ssh-...) +([^ ]*) *([^ \n]*)/ {
                err("Can't parse public key file $name")
                notify { "Can't parse public key file $name on the keymaster: skipping ensure => $ensure": }
            } else {
                $keytype = $1
                $modulus = $2
                $comment = $3
                ssh_authorized_key { $comment:
                    ensure  => "present",
                    user    => $username,
                    type    => $keytype,
                    key     => $modulus,
                    options => $options ? { "" => undef, default => $options },
                }
            }
        }
    } # user_keys

    # Create user accounts
    define create_user($uid, $email, $keyfiles) {
        $username = $title

        user { $username:
            ensure      => present,
            uid         => $uid,
            comment     => $email,
            home        => "/home/$username",
            shell       => "/bin/bash",
            managehome  => true,
            groups      => "wheel",
        }

        group { $username:
            gid         => $uid,
            require     => User[$username]
        }

        file { "/home/$username/":
            ensure      => directory,
            owner       => $username,
            group       => $username,
            mode        => 750,
            require     => [ User[$username], Group[$username] ]
        }

        file { "/home/$username/.ssh":
            ensure      => directory,
            owner       => $username,
            group       => $username,
            mode        => 700,
            require     => File["/home/$username/"]
        }

        user_keys { $keyfiles: }
    } # create_user



}
