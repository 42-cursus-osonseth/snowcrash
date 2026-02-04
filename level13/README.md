## LEVEL13

- Ce level contient un binaire `level13` : 
```bash
-rwsr-sr-x 1 flag13 level13 7303 Aug 30  2015 level13
```

- Lorsqu'on le lance : 
```bash
UID 2013 started us but we we expect 4242
```

- On analyse le binaire avec ghidra : 
```c
void main(void)

{
  __uid_t _Var1;
  undefined4 uVar2;
  
  _Var1 = getuid();
  if (_Var1 != 0x1092) {
    _Var1 = getuid();
    printf("UID %d started us but we we expect %d\n",_Var1,0x1092);
    exit(1);
  }
  uVar2 = ft_des("boe]!ai0FB@.:|L6l@A?>qJ}I");
  printf("your token is %s\n",uVar2);
  return;
}
```
- Le programme récupère l’UID réel avec getuid() et quitte si celui‑ci n’est pas 4242.

- Si l’UID est 4242, il appelle ft_des, qui retourne le token.

## EXPLOITATION

- Le binaire est SUID, mais il vérifie l’UID réel (getuid()) au lieu de l’UID effectif (geteuid()).
- L’idée est donc de bypasser le test en modifiant le flux d’exécution.
- En analysant le code assembleur :
```bash
 8048595:	e8 e6 fd ff ff       	call   8048380 <getuid@plt>
 804859a:	3d 92 10 00 00       	cmp    $0x1092,%eax
 804859f:	74 2a                	je     80485cb <main+0x3f>
```
- L’instruction JE (0x74) saute vers l’appel à ft_des uniquement si la condition est vraie.
Il suffit de remplacer ce saut conditionnel par un saut inconditionnel.
- JE rel8 → opcode 0x74
- JMP rel8 → opcode 0xEB
- Les deux instructions font 2 octets, l’offset (0x2a) reste valide.
- On ouvre le binaire en hexadécimal (ex. VSCode Hex Editor), on se place à l’offset correspondant (0x59f) et on remplace (74 par EB)
- Le programme saute alors toujours vers l’appel à ft_des, quel que soit l’UID.
- À l’exécution, le token est affiché.

## FLAG
- 2A31L79asukciNyi8uppkEuSx
