class users::install {
    # Create wheel group
    group { "wheel":
        ensure => present,
        gid     => 901,
    }

    # Create users
    create_user { "bogdan":
        uid      => 1001,
        email    => "bogdan.gaza@yahoo.com",
        home     => "/home/bogdan",
        keyfiles => "bogdan.pub"
    }


}
