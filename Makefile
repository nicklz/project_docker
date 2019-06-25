include .env

.PHONY: up down stop prune ps shell uli cim cex composer

default: up

up:
	@echo "Starting up containers for for $(PROJECT_NAME)..."
	docker-compose$(WINDOWS_SUPPORT) pull
	docker-compose$(WINDOWS_SUPPORT) up -d --remove-orphans
	@echo "Syncing folders... this may take a few minutes"
	@echo "-------------------------------------------------"
	@echo "-------------------------------------------------"
	@echo "-------------------------------------------------"
	@echo "Visit http://$(PROJECT_BASE_URL):$(PROJECT_PORT)3"
	@echo "-------------------------------------------------"
	@echo "-------------------------------------------------"
	@echo "-------------------------------------------------"


down:
	@echo "Removing containers."
	docker-compose$(WINDOWS_SUPPORT) down

stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	@docker-compose$(WINDOWS_SUPPORT) stop

prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	@docker-compose$(WINDOWS_SUPPORT) down -v

ps:
	@docker$(WINDOWS_SUPPORT) ps --filter name="$(PROJECT_NAME)*"

root:
	docker$(WINDOWS_SUPPORT) exec -u 0 -ti $(PROJECT_NAME)_web bash

shell:
	docker$(WINDOWS_SUPPORT) exec -ti $(PROJECT_NAME)_web bash

uli:
	@echo "Getting admin login"
	docker-compose$(WINDOWS_SUPPORT) run  drush uli --root=/var/www/project$(PROJECT_GIT_DOCROOT) --uri="$(PROJECT_BASE_URL)":$(PROJECT_PORT)3

cim:
	@echo "Importing Configuration"
	docker-compose$(WINDOWS_SUPPORT) run  drush cim -y --root=/var/www/project$(PROJECT_GIT_DOCROOT)
cex:
	@echo "Exporting Configuration"
	docker-compose$(WINDOWS_SUPPORT) run  drush cex -y --root=/var/www/project$(PROJECT_GIT_DOCROOT)

drush:
	@echo "Drush"
	docker-compose$(WINDOWS_SUPPORT) run $(MAKECMDGOALS) --root=/var/www/project$(PROJECT_GIT_DOCROOT) -y


install-source:
	@echo "Installing dependencies"
	docker-compose$(WINDOWS_SUPPORT) run web composer install --prefer-source

install:
	@echo "Installing dependencies"

	@echo "Cleaning up workspace"
	rm -rf data/www/project/ > /dev/null 2>&1
	@echo "Cloning codebase"
	git clone $(PROJECT_GIT) data/www/project
	make settings
	
settings:
	cp config/drupal/settings.php data/www/project$(PROJECT_GIT_DOCROOT)/sites/default/settings.local.php
	sed -i -e 's/PROJECT_NAME/$(PROJECT_NAME)/g' data/www/project$(PROJECT_GIT_DOCROOT)/sites/default/settings.local.php
	docker$(WINDOWS_SUPPORT) exec -u 0 -ti $(PROJECT_NAME)_web bash -c  'echo "create database $(PROJECT_NAME);" | mysql -uroot -h mysql --password="root"'


sync:
	docker$(WINDOWS_SUPPORT) exec -u 0 -ti $(PROJECT_NAME)_web bash -c  'echo "drop database $(PROJECT_NAME);" | mysql -uroot -h mysql --password="root"' > /dev/null 2>&1
	docker$(WINDOWS_SUPPORT) exec -u 0 -ti $(PROJECT_NAME)_web bash -c  'echo "create database $(PROJECT_NAME);" | mysql -uroot -h mysql --password="root"'
	docker$(WINDOWS_SUPPORT) exec -u 0 -ti $(PROJECT_NAME)_web bash -c  'mysql -u root -h mysql -p $(PROJECT_NAME) --password="root" < /var/www/dump.sql'
	make cr
download:
	rm -rf data/www/dump.sql && drush $(DRUSH_ALIAS) sql-dump > data/www/dump.sql
cr:
	@echo "Clearing Drupal Caches"
	docker-compose$(WINDOWS_SUPPORT) run  drush cr --root=/var/www/project$(PROJECT_GIT_DOCROOT)

logs:
	@echo "Displaying past containers logs"
	docker-compose$(WINDOWS_SUPPORT) logs

logsf:
	@echo "Follow containers logs output"
	docker-compose$(WINDOWS_SUPPORT) logs -f

composer:
	cd data/www/project && composer install
	cd data/www/project$(PROJECT_GIT_DOCROOT) && composer install

quickstart:
	make install && make up && make stop && make up && make download && make download && make sync 
