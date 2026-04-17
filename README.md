# Ematrica

iOS alkalmazás e-matrica vásárláshoz.

---

## API beüzemelése

Az alkalmazás egy helyi PHP API-val kommunikál, amelyet Docker segítségével lehet elindítani.

### Előfeltételek

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) telepítve és elindítva

### Indítás

1. Nyiss egy terminált (vagy Command Promptot / PowerShellt), navigálj bele a mappába, majd futtasd a következő parancsot:

```bash
cd api
```

2. Indítsd el a szervert Docker Compose segítségével:

```bash
docker compose up --build
```

Ha a terminálban azt látod, hogy Development Server (http://0.0.0.0:8080) started, az API készen áll a fogadásra.

### Leállítás

```bash
docker compose down
```

---

## Az alkalmazás futtatása

1. Indítsd el az API-t (lásd fentebb)
2. Nyisd meg az `Ematrica.xcodeproj` fájlt Xcode-ban
3. Futtasd az alkalmazást (`⌘R`)
