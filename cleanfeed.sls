cleanfeed-pkg:
  pkg.installed:
    - name: cleanfeed

cleanfeed-symlink:
  file.symlink:
    - name: /usr/local/news/bin/filter/filter_innd.pl
    - target: /usr/local/news/bin/filter/cleanfeed
    - mode: 644
    - owner: news
    - group: news
    - backupname: /usr/local/news/bin/filter/filter_innd.pl.orig
    - force: True

cleanfeed-config:
  file.managed:
    - name: /usr/local/news/cleanfeed/etc/cleanfeed.local
    - source: salt://inn/files/cleanfeed/cleanfeed.local
    - require:
      - pkg: cleanfeed-pkg

cleanfeed-reload:
  cmd.wait:
    - name: /usr/local/news/bin/ctlinnd reload filter.perl filtereload
    - user: news
    - watch:
      - file: cleanfeed-symlink
      - file: cleanfeed-config
    - require:
      - file: cleanfeed-symlink
      - file: cleanfeed-config
