set -e

echo "Create DB and Admin Users" 

# Create DB and Admin Users
cat > /tmp/db.sql <<EOF

--//----------------------------------------------------------------------------
--//Create pgdba
--//----------------------------------------------------------------------------
create user pgdba with
	login
	superuser
	createdb
	createrole
	inherit
	replication
	connection limit -1;

grant pg_monitor, pg_read_all_settings, pg_read_all_stats, pg_signal_backend, pg_stat_scan_tables, postgres to pgdba;

comment on role pgdba is 'The administrator of all the databases';

-------------------------------------------------------------------------------
--Create pgrdr
-------------------------------------------------------------------------------
create user pgrdr with
	login
	nosuperuser
	nocreatedb
	nocreaterole
	noinherit
	noreplication
	connection limit -1;

comment on role pgrdr is 'The reader of all the database';

-------------------------------------------------------------------------------
--Create pgwtr
-------------------------------------------------------------------------------
create user pgwtr with
	login
	nosuperuser
	nocreatedb
	nocreaterole
	inherit
	noreplication
	connection limit -1;

comment on role pgwtr is 'The account with rights to insert, delete, update, select on all of the database';

--------------------------------------------------------------------------------
--- Create Databases
--------------------------------------------------------------------------------

--//Create databases
--//  template0 database contains the same data as the initial contents of template1, that is, only the standard objects predefined by your version of PostgreSQL. 
--//  template0 should never be changed after the database cluster has been initialized. 
--//  By instructing CREATE DATABASE to copy template0 instead of template1, you can create a “virgin” user database that contains none of the site-local additions in template1. This is particularly handy when restoring a pg_dump dump: the dump script should be restored in a virgin database to ensure that one 
--// recreates the correct contents of the dumped database, without conflicting with objects that might have been added to template1 later on.
--// sort textual data, in the form of easy-to-read charts (http://collation-charts.org/) 


--//prod database
CREATE DATABASE dbapp
    WITH 
    OWNER = pgdba
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE dbapp
    IS 'live data';
	
CREATE DATABASE keycloak
    WITH 
    OWNER = pgdba
    TEMPLATE = template0
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;	
	
COMMENT ON DATABASE dbapp
    IS 'keycloak';	

ALTER USER pgdba WITH PASSWORD '${USER_PGDBA_PWD}';
ALTER USER pgwtr WITH PASSWORD '${USER_PGWTR_PWD}';
ALTER USER pgrdr WITH PASSWORD '${USER_PGRDR_PWD}';

ALTER ROLE pgdba SET search_path TO public;
ALTER ROLE pgwtr SET search_path TO public;
ALTER ROLE pgrdr SET search_path TO public;

EOF

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" < /tmp/db.sql