{% from "graylog/map.jinja" import host_lookup as config with context %}

/usr/lib/systemd/system/graylog-server.service:
  file.managed:
    - source: salt://graylog/files/graylog-server.service
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

/etc/sysconfig/graylog-server:
  file.managed:
    - source: salt://graylog/files/graylog-server.sysconfig
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

{{ config.graylog.base_dir }}/graylog-server/bin/graylog-server:
  file.managed:
    - source: salt://graylog/files/graylog-server.bin
    - template: jinja
    - user: graylog
    - group: graylog
    - mode: '0755'

service-graylog-server:
  service.running:
    - name: graylog-server
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/graylog-server.service
      - file: /etc/sysconfig/graylog-server
      - file: {{ config.graylog.base_dir }}/graylog-server/bin/graylog-server
    {% if config.graylog.restart_service_after_state_change == 'true' %}
    - watch:
      - file: /etc/graylog/server/server.conf
      - file: /etc/sysconfig/graylog-server
     {% endif %}
