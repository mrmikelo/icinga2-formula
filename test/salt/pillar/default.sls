# -*- coding: utf-8 -*-
# vim: ft=yaml
---
icinga2:
  lookup:  # See defaults.yaml and map.jinja for a better overview
    service: icinga2
    pkgs:
      - icinga2
      # - nagios-nrpe-plugin
    ido:
      db:
        # MUST BE SET when using icinga2.pgsql-ido
        password: SomeSecurePassword
    icinga_web2:
      db:
        # MUST BE SET when using icinga2.icinga-web2-database
        password: AnotherSecurePassword
      # pkgs:
      #   - ...
      # required_pkgs:
      #   - ...
      features:
        api: false  # disable
        command: true  # enable
        gelf: true
        graphite: true
        opentsdb: true
        perfdata: true
        statusdata: true
        # ...

    notification:
      xmpp:
        pkg: python3-slixmpp
        python_executable: python3
        ca_file: /etc/ssl/certs/ca-certificates.crt

  postgres:
    use_formula: true  # set to true if you are using postgres-formula

  nrpe:  # deprecated
    config:
      server_port: 5666
      commands:
        check_users: /usr/lib/nagios/plugins/check_users -w 5 -c 10
    defaults:
      DAEMON_OPTS: "\"--no-ssl\""

  conf:
    users:
      alice:
        email: alice@example.test
        groups:
          - icingaadmins
        vars:
          jabber: alice@jabber.example.test
    user_groups:
      # Using `alt` because only want this in `users.conf`, as shown in the docs:
      # - https://icinga.com/docs/icinga2/latest/doc/04-configuration/#usersconf
      icingaadmins_alt:
        display_name: "Icinga 2 Admin Group (alt)"
    templates:
      special-host:
        type: Host
        conf:
          vars:
            sla: "24x5"
      special-downtime:
        type: ScheduledDowntime
        conf:
          ranges:
            monday: "02:00-03:00"
      special-notification:
        type: Notification
        conf:
          types:
            - FlappingStart
            - FlappingEnd
    hosts:
      example.com:
        import: generic-host
        address: 1.2.3.4
        vars:
          sla: "24x7"
        services:
          http:
            import: generic-service
            host_name: example.com
            check_command: http
            vars:
              sla: "24x7"
          ssh:
            import: generic-service
            host_name: example.com
            check_command: ssh
            vars:
              sla: "24x7"
          ssh_alt:
            import: generic-service
            host_name: example.com
            check_command: ssh
            vars:
              ssh_port: 43
              sla: "24x7"

      # Minimalistic, supply only hostname
      example2.test: {}
      # # sets
      #   address: example2.test
      #   import: generic-host

      # Removes this host from Icinga
      deprecated.example.com:
        remove: true

    # notifications:
    #   'xmpp-host':
    #     # opt-in to trigger application
    #     apply_to: Host
    #     conf:
    #       users:
    #         - alice
    #       # defined by icinga.notification.xmpp
    #       command: 'xmpp-host-notification'
    #       assign:
    #         - 'true'

    downtimes: {}
    # see 'notifications' above

    services: {}
    # see 'notifications' above

  notification:
    xmpp:
      jid: icinga@jabber.example.test
      password: supersecurerandomizeduniquepassword
