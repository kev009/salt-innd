inn-pkg:
  pkg.installed:
    - name: inn

inn-config:
  file.recurse:
    - name: /usr/local/news/etc
    - source: salt://inn/files/etc

inn-innreport:
  file.directory:
    - names:
      - /usr/local/news/http
      - /usr/local/news/http/pics
    - user: news
    - group: news 

inn-shellvarslocal:
  file.managed:
    - name: /usr/local/news/etc/innshellvars.local
    - mode: 755
    - require:
      - file: inn-config

inn-service:
  service.running:
    - name: innd
    - enable: True
    - require:
      - pkg: inn-pkg
    - watch:
      - pkg: inn-pkg
      - file: inn-config

inn-syslog-conf:
  file.uncomment:
    - name: /etc/syslog.conf
    - regex: news+
    - char: '# '

inn-syslog-reload:
  service.running:
    - name: syslogd
    - reload: True
    - watch:
      - file: inn-syslog-conf

inn-newsusers-conf:
  file.managed:
    - name: /usr/local/news/etc/newsusers
    - contents_pillar: inn:newsusers
    - user: news
    - mode: 640
    - require:
      - pkg: inn-pkg

# Expire old news and overview entries nightly, generate reports.
inn-cron-daily:
  cron.present:
    - name: /usr/local/news/bin/news.daily expireover lowmark delayrm nomail
    - identifier: inn-daily
    - user: news
    - minute: 15
    - hour: 4
    - require:
      - pkg: inn-pkg
      - file: inn-config

# Refresh the cached IP addresses every day.
inn-cron-flush-ip-cache:
  cron.present:
    - name: /usr/local/news/bin/ctlinnd -t 300 -s reload incoming.conf "flush cache"
    - identifier: inn-flush-ip-cache
    - user: news
    - minute: 2
    - hour: 3
    - require:
      - pkg: inn-pkg
      - file: inn-config

# Every hour, run an rnews -U. This is not only for UUCP sites, but
# also to process queud up articles put there by nnrpd in case
# innd wasn't accepting any articles.
inn-cron-rnews:
  cron.present:
    - name: /usr/local/news/bin/rnews -U
    - identifier: inn-rnews
    - user: news
    - minute: 10
    - require:
      - pkg: inn-pkg
      - file: inn-config

# Sync the groups we carry against isc.org master list
inn-actsyncd:
  cron.present:
    - name: /usr/local/news/bin/actsyncd /usr/local/news/etc/actsync.cfg
    - identifier: inn-actsyncd
    - user: news
    - hour: 6
    - minute: 2
    - require:
      - pkg: inn-pkg
      - file: inn-config

inn-cron-flush-inpaths:
  cron.present:
    - name: /usr/local/news/bin/ctlinnd -s -t 60 flush inpaths!
    - identifier: inn-flush-inpaths
    - user: news
    - minute: 6
    - hour: 6
    - require:
      - pkg: inn-pkg
      - file: inn-config

inn-cron-sendinpaths:
  cron.present:
    - name: /usr/local/news/bin/sendinpaths
    - identifier: inn-sendinpaths
    - user: news
    - minute: 8
    - hour: 6
    - require:
      - pkg: inn-pkg
      - file: inn-config
