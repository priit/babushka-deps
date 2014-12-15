Build scripts
-------------

Babushka based build scripts for deplomyent Ruby on Rails applications.

Please inspect those scripts before running anything, they might not
be complete or might have serious bugs. 

However you are free to fork it.

### Usage

Used and tested on Debian 7

Example usage to create dedicated linux user and app

     # on server side
     apt-get install curl
     sh -c "`curl https://babushka.me/up`"
     babushka priit:app_user
     babushka priit:app

Currently 15.12.2014 those scripts are not yet fully complete.
