# Installation Instructions (Drupal 8) 

1. Install https://docs.docker.com/install/
2. git clone git@github.com:nicklz/project_docker.git projectname
3. cd projectname
4. cp .env.example .env && vi .env (Configure fields here)
5. make install && make up && make sync (repeat make up && make sync if this fails)
6. make rsync (then ctrl + Z if you dont like watching the files syncing)
7. Add 127.0.0.1 local.projectname.com to hosts file
8. Visit project website entered in .env file (example: local.projectname.com:20003)

or git clone git@github.com:nicklz/project_docker.git projectname && cd projectname && cp .env.example .env && make install && make up && make up && sleep 120 && make up && make sync && make rsync

