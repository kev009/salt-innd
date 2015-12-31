# salt-innd
Salt formula for inn, the InterNetNews service.

**Implementation choices:**

* It functions as a self-contained spooler/reader on a single server and tries
to ensure best practice for a text feed.
* The formula is specific to the FreeBSD packaging and only carries conf files
which need to change.
* tradspool and tradindexed overview because ZFS makes this childsplay on modern hardware.
Check out csiph.com innreport to get an idea of volume for a text-only public
Usenet service for Big-8.  I expect unlimited retention with current disk sizes.

## Getting started
For a private node, decide if you want to create local groups only, or if you
want to set up suck to pull from a public server.  If local groups only, delete actsync stuff.

For a public Usenet service, you will need to arrange peering and edit the
newsfeeds, innfeed.conf, and incoming.conf.

Take a look at all the things in the files directory and edit them in accordance
with man pages and the INN FAQ.

## NoCeM

Out of the box NoCeM is enabled.  There's a gpg keyring that accepts
http://rosalind.home.xs4all.nl/nocemreg/nocemreg.html, but a couple of these no
longer work with GnuPG 2.1.

## init

This is the main formula for setting up inn and associated tasks.

## cleanfeed

Basic cleanfeed settings to ensure a high quality text feed.  Highly
recommended.

## suck

This will allow you to suck news from a public reader server if you want a
backup to peering or do not wish to run an internet facing node.

## pillar.example

The server defaults to allow all read-only, but posting must be authenticated.

Authorized posting users are stored in the pillar as username:cryptpwhash pairs.

## References
* http://www.eyrie.org/~eagle/faqs/inn.html
* http://csiph.com/
