## LEVEL02

- Dans ce level, on trouve un fichier level02.pcap dans /home/user/level02    
Les fichier .pcap  sont des fichiers de données créés en utilisant wireshark et ils contiennent les données en paquets d'un réseau.  
En ouvrant et analysant le fichier avec wireshark on peut voir ce block de donnees en hexdump :

```diff
000000D6  00 0d 0a 50 61 73 73 77  6f 72 64 3a 20            ...Passw ord:
000000B9  66                                                 f
000000BA  74                                                 t
000000BB  5f                                                 _
000000BC  77                                                 w
000000BD  61                                                 a
000000BE  6e                                                 n
000000BF  64                                                 d
000000C0  72                                                 r
-000000C1  7f                                                 .
-000000C2  7f                                                 .
-000000C3  7f                                                 .
000000C4  4e                                                 N
000000C5  44                                                 D
000000C6  52                                                 R
000000C7  65                                                 e
000000C8  6c                                                 l
-000000C9  7f                                                 .
000000CA  4c                                                 L
000000CB  30                                                 0
000000CC  4c                                                 L
000000CD  0d                                                 .
```

Les lignes en rouge sont des DEL effectue par l utilisateur, il a donc rentre comme mot de passe : ft_waNDReLOL

## FLAG 

- kooda2puivaav1idi4f57q8iq
