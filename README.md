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

---

## Térkép Implementációs Terv

A Figma dizájnban szereplő térkép exportálása korlátozott volt, mivel a Developer Mode használatához és az elemek exportálásához további jogosultságok lettek volna szükségesek. Emiatt a következők szerint valósítanám meg:

**SVG-to-SwiftUI:** A vármegyék határait reprezentáló geometriai adatokat (Path data) vármegyénként különálló SwiftUI Shape objektumokká alakítanám.

A megyéket egy ZStack struktúrába rendezném, ahol az API-ból érkező egyedi azonosítók (pl. YEAR_11) alapján történne a renderelés.

**Kiválasztott megye:** A `isSelected` állapot hatására a terület színe dinamikusan változna (pl. `.fill(Color.green)`).

**Kétirányú szinkron:** A térképen való kattintás (`onTapGesture`) ugyanazt a logikai eseményt váltaná ki a ViewModel-ben, mint a listaelem kiválasztása, így a UI minden eleme azonnal frissülne.
