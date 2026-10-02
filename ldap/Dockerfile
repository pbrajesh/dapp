FROM        debian:bullseye-slim

## install slapd in noninteractive mode
RUN echo 'slapd/password1 password password' | debconf-set-selections &&\
    echo 'slapd/password2 password password' | debconf-set-selections && \
            DEBIAN_FRONTEND=noninteractive apt update -yq && \
            DEBIAN_FRONTEND=noninteractive apt install -yq \                
                ldap-utils \
                ldapscripts \                
                slapd 
	
RUN         DEBIAN_FRONTEND=noninteractive apt clean && \            
            rm -fr /var/lib/apt/lists/*	

EXPOSE      389 636

VOLUME      ["/etc/ldap/slapd.d", "/var/lib/ldap"]

ENTRYPOINT  ["slapd"]

CMD         ["-h", "ldap:/// ldapi:/// ldaps:///", "-u", "openldap", "-g", "openldap", "-dStats,Stats2"]