# Dev
```
nix-shell shell.nix
```

# Ops
Create deployment state.
```
nixops create server.nix vultr/vultr.nix -d blog
```

Deploy
```
nixops deploy -d blog
```
