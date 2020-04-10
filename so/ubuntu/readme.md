# Ubuntu

## Test Bitbucket

```bash
ssh -T git@bitbucket.org
```

## Placa de vídeo

Nvidia GTX Drivers

```sh
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update
sudo ubuntu-drivers list
sudo apt-get install nvidia-*last_version*
```

<https://www.maketecheasier.com/install-nvidia-drivers-ubuntu/>

```text
edit /etc/gdm3/custom.conf and uncomment the line:
#WaylandEnable=false
```
