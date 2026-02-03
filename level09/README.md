## LEVEL09

- Comme pour le level précédent, un binaire `level09` et un fichier `token` : 
```bash
-rwsr-sr-x 1 flag09 level09 7640 Mar  5  2016 level09
----r--r-- 1 flag09 level09   26 Mar  5  2016 token
```

- Bit SUID pour le binaire, qui sera exécuté avec les droits de flag09.
- Le fichier token appartient à flag09 et a un droit de lecture pour level09.

- Un `cat` sur le token affiche :
```bash
f4kmm6p|=�p�n��DB�Du{��
```

- On utilise ghidra comme pour le level précédent pour décompiler et comprendre ce que fait le binaire :
```c

size_t main(int param_1,int param_2)

{
  char cVar1;
  bool bVar2;
  long lVar3;
  size_t sVar4;
  char *pcVar5;
  int iVar6;
  int iVar7;
  uint uVar8;
  int in_GS_OFFSET;
  byte bVar9;
  uint local_120;
  undefined1 local_114 [256];
  int local_14;
  
  bVar9 = 0;
  local_14 = *(int *)(in_GS_OFFSET + 0x14);
  bVar2 = false;
  local_120 = 0xffffffff;
  lVar3 = ptrace(PTRACE_TRACEME,0,1,0);
  if (lVar3 < 0) {
    puts("You should not reverse this");
    sVar4 = 1;
  }
  else {
    pcVar5 = getenv("LD_PRELOAD");
    if (pcVar5 == (char *)0x0) {
      iVar6 = open("/etc/ld.so.preload",0);
      if (iVar6 < 1) {
        iVar6 = syscall_open("/proc/self/maps",0);
        if (iVar6 == -1) {
          fwrite("/proc/self/maps is unaccessible, probably a LD_PRELOAD attempt exit..\n",1,0x46,
                 stderr);
          sVar4 = 1;
        }
        else {
          do {
            do {
              while( true ) {
                iVar7 = syscall_gets(local_114,0x100,iVar6);
                sVar4 = 0;
                if (iVar7 == 0) goto LAB_08048a77;
                iVar7 = isLib(local_114,&DAT_08048c2b);
                if (iVar7 == 0) break;
                bVar2 = true;
              }
            } while (!bVar2);
            iVar7 = isLib(local_114,&DAT_08048c30);
            if (iVar7 != 0) {
              if (param_1 == 2) goto LAB_08048996;
              sVar4 = fwrite("You need to provied only one arg.\n",1,0x22,stderr);
              goto LAB_08048a77;
            }
            iVar7 = afterSubstr(local_114,"00000000 00:00 0");
          } while (iVar7 != 0);
          sVar4 = fwrite("LD_PRELOAD detected through memory maps exit ..\n",1,0x30,stderr);
        }
      }
      else {
        fwrite("Injection Linked lib detected exit..\n",1,0x25,stderr);
        sVar4 = 1;
      }
    }
    else {
      fwrite("Injection Linked lib detected exit..\n",1,0x25,stderr);
      sVar4 = 1;
    }
  }
LAB_08048a77:
  if (local_14 == *(int *)(in_GS_OFFSET + 0x14)) {
    return sVar4;
  }
                    /* WARNING: Subroutine does not return */
  __stack_chk_fail();
LAB_08048996:
  local_120 = local_120 + 1;
  uVar8 = 0xffffffff;
  pcVar5 = *(char **)(param_2 + 4);
  do {
    if (uVar8 == 0) break;
    uVar8 = uVar8 - 1;
    cVar1 = *pcVar5;
    pcVar5 = pcVar5 + (uint)bVar9 * -2 + 1;
  } while (cVar1 != '\0');
  if (~uVar8 - 1 <= local_120) goto code_r0x080489ca;
  putchar((int)*(char *)(local_120 + *(int *)(param_2 + 4)) + local_120);
  goto LAB_08048996;
code_r0x080489ca:
  sVar4 = fputc(10,stdout);
  goto LAB_08048a77;
}
```

- La première partie est composée de différents contrôles d'injection de librairie afin d’interdire l'usurpation de fonctions.  
- On voit aussi que le programme n’ouvre pas de fichier mais prend argv[1] tel quel, il faut donc lui passer le contenu du token.
```bash
./level09 $(cat token)
f5mpq;v�E��{�{��TS�W�����
```
- Cela ne change pas grand chose, la sortie n'est toujours pas un token valide et affiche des caractères non imprimables.

## EXPLOITATION
- On essaie de comprendre ce que fait le binaire, afin de trouver une logique pour afficher le token de flag09.
- La partie intéressante est celle-ci : 
```c
LAB_08048996:
  local_120 = local_120 + 1;
  uVar8 = 0xffffffff;
  pcVar5 = *(char **)(param_2 + 4);
  do {
    if (uVar8 == 0) break;
    uVar8 = uVar8 - 1;
    cVar1 = *pcVar5;
    pcVar5 = pcVar5 + (uint)bVar9 * -2 + 1;
  } while (cVar1 != '\0');
  if (~uVar8 - 1 <= local_120) goto code_r0x080489ca;
  putchar((int)*(char *)(local_120 + *(int *)(param_2 + 4)) + local_120);
  goto LAB_08048996;
code_r0x080489ca:
  sVar4 = fputc(10,stdout);
  goto LAB_08048a77;
}
```
- La boucle parcourt tous les caractères de argv[1] et les affiche en rajoutant l’index à la valeur de argv[1][i];

```c
argv[1][i] + i // passé à putchar
```

- Chaque caractère de l’entrée est transformé par une addition de son index (argv[1][i] + i), mais comme vu plus haut la sortie affiche toujours des caraceres non imprimable.  
On tente donc de faire la même chose en écrivant un petit programme qui produira la même logique mais en faisant une soustraction de l'index;
```c
#include <stdio.h>

int main (int argc, char ** argv){

    int i = 0;
    while (argv[1][i])
    {
        putchar(argv[1][i] - i);
        i++;
    }
    printf("\n");
}
```
- On envoie le fichier token sur la machine host: 
```bash
scp -P 4242 level09@192.168.56.16:/home/user/level09/token .
```
- On compile notre programme et on lui envoie le contenu de token :
```bash
cc -o gettoken main.c
/gettoken $(cat token)
f3iji1ju5yuevaus41q1afiuq
```

- On a récupéré le token de  flag09, ce qui permet d'accéder à flag09 et ensuite de lancer getflag afin de récupérer le flag pour le level suivant.

## FLAG 

- s5cAJpM8ev6XHw998pRWG728z

