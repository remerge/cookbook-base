if node[:platform] == 'ubuntu'
  default[:baselayout][:groups] = {
    root: {
      gid: 0,
      members: '',
    },
    daemon: {
      gid: 1,
      members: '',
    },
    bin: {
      gid: 2,
      members: '',
    },
    sys: {
      gid: 3,
      members: '',
    },
    adm: {
      gid: 4,
      members: '',
      append: true,
    },
    tty: {
      gid: 5,
      members: '',
    },
    disk: {
      gid: 6,
      members: '',
    },
    lp: {
      gid: 7,
      members: '',
    },
    mail: {
      gid: 8,
      members: '',
      append: true,
    },
    news: {
      gid: 9,
      members: '',
    },
    uucp: {
      gid: 10,
      members: '',
    },
    man: {
      gid: 12,
      members: '',
    },
    proxy: {
      gid: 13,
      members: '',
    },
    kmem: {
      gid: 15,
      members: '',
    },
    dialout: {
      gid: 20,
      members: '',
    },
    fax: {
      gid: 21,
      members: '',
    },
    voice: {
      gid: 22,
      members: '',
    },
    cdrom: {
      gid: 24,
      members: '',
    },
    floppy: {
      gid: 25,
      members: '',
    },
    tape: {
      gid: 26,
      members: '',
    },
    sudo: {
      gid: 27,
      members: '',
      append: true,
    },
    audio: {
      gid: 29,
      members: '',
    },
    dip: {
      gid: 30,
      members: '',
    },
    :'www-data' => {
      gid: 33,
      members: '',
    },
    backup: {
      gid: 34,
      members: '',
    },
    operator: {
      gid: 37,
      members: '',
    },
    list: {
      gid: 38,
      members: '',
    },
    irc: {
      gid: 39,
      members: '',
    },
    src: {
      gid: 40,
      members: '',
    },
    gnats: {
      gid: 41,
      members: '',
    },
    shadow: {
      gid: 42,
      members: '',
    },
    utmp: {
      gid: 43,
      members: '',
    },
    video: {
      gid: 44,
      members: '',
    },
    sasl: {
      gid: 45,
      members: '',
    },
    plugdev: {
      gid: 46,
      members: '',
    },
    staff: {
      gid: 50,
      members: '',
    },
    games: {
      gid: 60,
      members: '',
    },
    users: {
      gid: 100,
      members: '',
      append: true,
    },
    nogroup: {
      gid: 65_534,
      members: '',
    },
  }

  default[:baselayout][:users] = {
    daemon: {
      uid: 1,
      gid: 1,
      home: '/usr/sbin',
      shell: '/usr/sbin/nologin',
    },
    bin: {
      uid: 2,
      gid: 2,
      home: '/bin',
      shell: '/usr/sbin/nologin',
    },
    sys: {
      uid: 3,
      gid: 3,
      home: '/dev',
      shell: '/usr/sbin/nologin',
    },
    sync: {
      uid: 4,
      gid: 65_534,
      home: '/bin',
      shell: '/bin/sync',
    },
    games: {
      uid: 5,
      gid: 60,
      home: '/usr/games',
      shell: '/usr/sbin/nologin',
    },
    man: {
      uid: 6,
      gid: 12,
      home: '/var/cache/man',
      shell: '/usr/sbin/nologin',
    },
    lp: {
      uid: 7,
      gid: 7,
      home: '/var/spool/lpd',
      shell: '/usr/sbin/nologin',
    },
    mail: {
      uid: 8,
      gid: 8,
      home: '/var/mail',
      shell: '/usr/sbin/nologin',
    },
    news: {
      uid: 9,
      gid: 9,
      home: '/var/spool/news',
      shell: '/usr/sbin/nologin',
    },
    uucp: {
      uid: 10,
      gid: 10,
      home: '/var/spool/uucp',
      shell: '/usr/sbin/nologin',
    },
    proxy: {
      uid: 13,
      gid: 13,
      home: '/bin',
      shell: '/usr/sbin/nologin',
    },
    :'www-data' => {
      uid: 33,
      gid: 33,
      home: '/var/www',
      shell: '/usr/sbin/nologin',
    },
    backup: {
      uid: 34,
      gid: 34,
      home: '/var/backups',
      shell: '/usr/sbin/nologin',
    },
    list: {
      uid: 38,
      gid: 38,
      comment: 'Mailing List Manager',
      home: '/var/list',
      shell: '/usr/sbin/nologin',
    },
    irc: {
      uid: 39,
      gid: 39,
      comment: 'ircd',
      home: '/var/run/ircd',
      shell: '/usr/sbin/nologin',
    },
    gnats: {
      uid: 41,
      gid: 41,
      comment: 'Gnats Bug-Reporting System (admin)',
      home: '/var/lib/gnats',
      shell: '/usr/sbin/nologin',
    },
    nobody: {
      uid: 65_534,
      gid: 65_534,
      home: '/nonexistent',
      shell: '/usr/sbin/nologin',
    },
  }
end
