# Installation Instructions (Drupal 8 + WSL2) 

1. Install WSL2 (https://docs.microsoft.com/en-us/windows/wsl/wsl2-install) and docker 
2. git clone git@github.com:nicklz/project_docker.git projectname
3. cd projectname
4. cp .env.example .env && vi .env (Configure fields here)
5. sudo make install && sudo make up
6. sudo make download (or place database sql dump in data/www/dump.sql)
7. sudo make sync
8. Add ip from command:   ip addr | grep eth0     with local.projectname.com to hosts file
9. sudo make uli (and use link to log into site)


