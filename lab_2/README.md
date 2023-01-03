# WUS22Z - Laboratorium 1

## Zespół

```
Bartłomiej Krawczyk
Karol Kasperek
Mateusz Brzozowski
Aleksandra Majewska
```

## Sposób odpalania

1. Należy postawić maszyny wirtualne, można to zrobić korzystając ze skryptu znajdującego się w folderze `/vms/`:

```bash
cd /vms/
./deploy.sh ./config.json
```

Program ten wyświetli na koniec 3 adresy ip oraz miejsce pobranego klucza publicznego.

2. Należy uzupełnić odpowiedni `inventory_n.yml` tymi adresami ip, kluczem publicznym oraz nazwą użytkownika.

3. Należy wybrać konfigurację poprzez odkomentowanie odpowiedniej konfiguracji z `ansible.cfg`

4. Wybraną konfigurację odpalamy poprzez 
```bash
./run.sh
```
