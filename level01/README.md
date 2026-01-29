## LEVEL01

- Dans ce level , en affichant le fichier /etc/passwd on peut voir une ligne interessante : flag01:42hDRfypTqqnw:3001:3001::/home/flag/flag01:/bin/bash.      
Sur les ancien systemes Unix les hashs de mots de passe étaient stockés directement dans /etc/passwd.
Le format de ce hash correspond a DES crypt, un ancien algorithme de hachage de mots de passe utilisé sur les premiers systèmes Unix.

## JOHN THE RIPPER

- On va avoir besoin de john the Ripper, il est utilisé pour casser le hash (attaque dictionnaire / brute‑force).
- Pour commencer installons le :

```bash
git clone https://github.com/openwall/john.git
cd john/src
./configure
make
```

- Ensuite il suffit de copier le hash dans un fichier, par exemple hash.txt  
- Puis de lancer :
```bash
./john hash.txt
```

- La sortie affiche : 
```bash
Proceeding with wordlist:./password.lst
Enabling duplicate candidate password suppressor using 256 MiB
abcdefg          (?)     
```

- On a donc trouver le mot de passe qui est : abcdefg

## FLAG 

- f2av5il02puano7naaf6adaaf
