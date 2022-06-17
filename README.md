# Almalinux 8.6 con dind e terraform

## Script di esecuzione

```
curl -sSL https://raw.githubusercontent.com/manprint/almalinux-dind/main/almalinux-dind.sh -o almalinux-dind.sh
```
```
chmod +x almalinux-dind.sh
```

## Script di deploy terraform

```
curl -sSL https://raw.githubusercontent.com/manprint/almalinux-dind/main/terraform/main.tf -o main.tf
```
```
curl -sSl https://raw.githubusercontent.com/manprint/almalinux-dind/main/terraform/Makefile -o Makefile
```