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
    define create_user($uid, $email, $home, $keyfiles) {
        $username = $title

        user { $username:
            ensure      => present,
            uid         => $uid,
            comment     => $email,
            home        => $home,
            shell       => "/bin/bash",
            managehome  => true,
            groups      => "wheel",
        }
      
        exec { "/opt/tools/setuserpassword $username":
            path            => "/bin:/usr/bin",
            refreshonly     => true,
            unless          => "cat /etc/shadow | grep $username | cut -f 2 -d : | grep -v '!'",
            require         => [Class["tools"],User[$username]]
        }

        group { $username:
            gid         => $uid,
            require     => User[$username]
        }

        file { $home :
            ensure      => directory,
            owner       => $username,
            group       => $username,
            mode        => 750,
            require     => [ User[$username], Group[$username] ]
        }

        file { "$home/.ssh":
            ensure      => directory,
            owner       => $username,
            group       => $username,
            mode        => 700,
            require     => File["$home"]
        }

        user_keys { "$keyfiles":
        }
    } # create_user

define git_clone(   $source,
                $localtree = "/opt/stack/",
                $real_name = false,
                $branch = false) {
    if $real_name {
        $_name = $real_name
    }
    else {
        $_name = $name
    }

    if !$branch {
      $branch = "master"
    }
    
    exec { "git_clone_exec_$localtree/$_name":
        path => "/bin:/usr/bin",
        cwd => $localtree,
        command => "git clone -b $branch $source $_name",
        user => "stack",
        group => "stack",
        unless => "test -d $localtree/$_name",
        timeout => 0,
        logoutput => on_failure
    }

}

define pip($ensure = installed) {
    require "git"
    case $ensure {
        installed: {
            exec { "pip install $name":
                path => "/usr/local/bin:/usr/bin:/bin",
                environment => "PIP_DOWNLOAD_CACHE=/var/cache/pip",
                logoutput => on_failure,
                require => Class["git"],
                unless => "pip freeze | grep \"$name\""
            }
        }
        latest: {
            exec { "pip install --upgrade $name":
                path => "/usr/local/bin:/usr/bin:/bin",
            }
        }
        default: {
            exec { "pip install $name==$ensure":
                path => "/usr/local/bin:/usr/bin:/bin",
            }
        }
    }
}
