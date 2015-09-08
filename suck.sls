suck-pkg:
  pkg.installed:
    - name: suck

suck-cron:
  cron.present:
    - name: /usr/local/bin/suck csiph.com -A -bp -hl localhost -c -i 200 -M -n >/dev/null 2>&1
    - identifier: suck
    - user: news
    - minute: '*/44'
