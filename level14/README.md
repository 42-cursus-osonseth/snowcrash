## LEVEL14

- Dans ce level, il n’y a aucun fichier ni quoi que ce soit pour aider a trouver le flag.

- On pense donc à faire la même chose qu'au level precedent mais avec le binaire `/getflag` directement.

- On analyse le binaire avec ghidra : 
```c

undefined4 main(void)

{
  bool bVar1;
  FILE *__stream;
  long lVar2;
  undefined4 uVar3;
  char *pcVar4;
  int iVar5;
  __uid_t _Var6;
  int iVar7;
  int in_GS_OFFSET;
  undefined1 local_114 [256];
  int local_14;
  
  local_14 = *(int *)(in_GS_OFFSET + 0x14);
  bVar1 = false;
  lVar2 = ptrace(PTRACE_TRACEME,0,1,0);
  if (lVar2 < 0) {
    puts("You should not reverse this");
    uVar3 = 1;
  }
  else {
    pcVar4 = getenv("LD_PRELOAD");
    if (pcVar4 == (char *)0x0) {
      iVar5 = open("/etc/ld.so.preload",0);
      if (iVar5 < 1) {
        iVar5 = syscall_open("/proc/self/maps",0);
        if (iVar5 == -1) {
          fwrite("/proc/self/maps is unaccessible, probably a LD_PRELOAD attempt exit..\n",1,0x46,
                 stderr);
          uVar3 = 1;
        }
        else {
          do {
            do {
              while( true ) {
                iVar7 = syscall_gets(local_114,0x100,iVar5);
                if (iVar7 == 0) goto LAB_08048ead;
                iVar7 = isLib(local_114,&DAT_08049063);
                if (iVar7 == 0) break;
                bVar1 = true;
              }
            } while (!bVar1);
            iVar7 = isLib(local_114,&DAT_08049068);
            if (iVar7 != 0) {
              fwrite("Check flag.Here is your token : ",1,0x20,stdout);
              _Var6 = getuid();
              __stream = stdout;
              if (_Var6 == 0xbbe) {
                pcVar4 = (char *)ft_des("H8B8h_20B4J43><8>\\ED<;j@3");
                fputs(pcVar4,__stream);
              }
              else if (_Var6 < 0xbbf) {
                if (_Var6 == 0xbba) {
                  pcVar4 = (char *)ft_des("<>B16\\AD<C6,G_<1>^7ci>l4B");
                  fputs(pcVar4,__stream);
                }
                else if (_Var6 < 0xbbb) {
                  if (_Var6 == 3000) {
                    pcVar4 = (char *)ft_des("I`fA>_88eEd:=`85h0D8HE>,D");
                    fputs(pcVar4,__stream);
                  }
                  else if (_Var6 < 0xbb9) {
                    if (_Var6 == 0) {
                      fwrite("You are root are you that dumb ?\n",1,0x21,stdout);
                    }
                    else {
LAB_08048e06:
                      fwrite("\nNope there is no token here for you sorry. Try again :)",1,0x38,
                             stdout);
                    }
                  }
                  else {
                    pcVar4 = (char *)ft_des("7`4Ci4=^d=J,?>i;6,7d416,7");
                    fputs(pcVar4,__stream);
                  }
                }
                else if (_Var6 == 0xbbc) {
                  pcVar4 = (char *)ft_des("?4d@:,C>8C60G>8:h:Gb4?l,A");
                  fputs(pcVar4,__stream);
                }
                else if (_Var6 < 0xbbd) {
                  pcVar4 = (char *)ft_des("B8b:6,3fj7:,;bh>D@>8i:6@D");
                  fputs(pcVar4,__stream);
                }
                else {
                  pcVar4 = (char *)ft_des("G8H.6,=4k5J0<cd/D@>>B:>:4");
                  fputs(pcVar4,__stream);
                }
              }
              else if (_Var6 == 0xbc2) {
                pcVar4 = (char *)ft_des("74H9D^3ed7k05445J0E4e;Da4");
                fputs(pcVar4,__stream);
              }
              else if (_Var6 < 0xbc3) {
                if (_Var6 == 0xbc0) {
                  pcVar4 = (char *)ft_des("bci`mC{)jxkn<\"uD~6%g7FK`7");
                  fputs(pcVar4,__stream);
                }
                else if (_Var6 < 0xbc1) {
                  pcVar4 = (char *)ft_des("78H:J4<4<9i_I4k0J^5>B1j`9");
                  fputs(pcVar4,__stream);
                }
                else {
                  pcVar4 = (char *)ft_des("Dc6m~;}f8Cj#xFkel;#&ycfbK");
                  fputs(pcVar4,__stream);
                }
              }
              else if (_Var6 == 0xbc4) {
                pcVar4 = (char *)ft_des("8_Dw\"4#?+3i]q&;p6 gtw88EC");
                fputs(pcVar4,__stream);
              }
              else if (_Var6 < 0xbc4) {
                pcVar4 = (char *)ft_des("70hCi,E44Df[A4B/J@3f<=:`D");
                fputs(pcVar4,__stream);
              }
              else if (_Var6 == 0xbc5) {
                pcVar4 = (char *)ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");
                fputs(pcVar4,__stream);
              }
              else {
                if (_Var6 != 0xbc6) goto LAB_08048e06;
                pcVar4 = (char *)ft_des("g <t61:|4_|!@IF.-62FH&G~DCK/Ekrvvdwz?v|");
                fputs(pcVar4,__stream);
              }
              fputc(10,stdout);
              goto LAB_08048ead;
            }
            iVar7 = afterSubstr(local_114,"00000000 00:00 0");
          } while (iVar7 != 0);
          fwrite("LD_PRELOAD detected through memory maps exit ..\n",1,0x30,stderr);
LAB_08048ead:
          uVar3 = 0;
        }
      }
      else {
        fwrite("Injection Linked lib detected exit..\n",1,0x25,stderr);
        uVar3 = 1;
      }
    }
    else {
      fwrite("Injection Linked lib detected exit..\n",1,0x25,stderr);
      uVar3 = 1;
    }
  }
  if (local_14 == *(int *)(in_GS_OFFSET + 0x14)) {
    return uVar3;
  }
                    /* WARNING: Subroutine does not return */
  __stack_chk_fail();
}
```
## EXPLOITATION

- On voit que le block qui affiche le token de flag14 est celui-ci : 
```c
else {
if (_Var6 != 0xbc6) goto LAB_08048e06;
pcVar4 = (char *)ft_des("g <t61:|4_|!@IF.-62FH&G~DCK/Ekrvvdwz?v|");
fputs(pcVar4,__stream);
}
```

- Ce bloc de code assembleur est la partie qui rentre dans la condition `UID == flag14` pour afficher son token : 
```asm
                             LAB_08048de5                                    XREF[1]:     08048bbb(j)  
        08048de5 a1 60 b0        MOV        EAX,[stdout]
                 04 08
        08048dea 89 c3           MOV        EBX,EAX
        08048dec c7 04 24        MOV        dword ptr [ESP]=>local_130,s_g_<t61:|4_|!@IF.-   = "g <t61:|4_|!@IF.-62FH&G~DCK/E
                 20 92 04 08
        08048df3 e8 0c f8        CALL       ft_des                                           undefined ft_des()
                 ff ff
        08048df8 89 5c 24 04     MOV        dword ptr [ESP + local_12c],EBX
        08048dfc 89 04 24        MOV        dword ptr [ESP]=>local_130,EAX
        08048dff e8 2c f7        CALL       <EXTERNAL>::fputs                                int fputs(char * __s, FILE * __s
                 ff ff
        08048e04 eb 29           JMP        LAB_08048e2f

```
- On peut directement lancer le binaire sur la VM avec gdb et jmp à l’adresse `08048de5` :
```bash
jump *0x08048de5
```

- On peut aussi récupérer le binaire sur le host et le patch :  
```asm
        08048990 79 16           JNS        LAB_080489a8
        08048992 c7 04 24        MOV        dword ptr [ESP]=>local_130,s_You_should_not_re   = "You should not reverse this"
                 a8 8f 04 08
```
On remplace les 2 instructions ci-dessus par un jmp a l'adresse `08048ad5`.
```asm
        08048b02 89 44 24 18     MOV        dword ptr [ESP + local_118],EAX
        08048b06 8b 44 24 18     MOV        EAX,dword ptr [ESP + local_118]
```
Et on remplace les 2 instrucitons ci-dessus par un `mov eax, 0xbc6`, qui est la valeur de l’UID de flag14.

## FLAG
- 7QiHafiNa3HVozsaXkawuYrTstxbpABHD8CPnHJ
