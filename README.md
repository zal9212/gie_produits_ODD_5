# GIE Produits — Gestion de transformation de produits locaux

> **Application de gestion d'un GIE féminin de transformation de produits locaux**
> Projet academique — Licence 3, Module Developpement Multiplateforme
> ESMT Dakar | Promotion DAR26 | 2026

---

## A propos

**GIE Produits** est une application multi-plateforme developpee avec **Flutter** qui permet a un Groupement d'Interet Economique (GIE) feminin de gerer son inventaire de produits transformes issus de ressources locales senegalaises.

L'application s'inscrit dans l'objectif **ODD 5 — Egalite entre les sexes** des Nations Unies, en outillant numeriquement une cooperative de femmes pour le suivi de leur production et de leurs ventes.

### Origine des donnees

Les produits de demonstration sont inspires de **[Jolof Teranga](https://jolofteranga.com)** — un GIE senegalais specialise dans les plantes medicinales et produits naturels.

---

## Fonctionnalites

| Fonctionnalite | Detail |
|---|---|
| **CRUD complet** | Ajouter, modifier, consulter et supprimer des produits |
| **Filtres** | Filtrer les produits par statut : Tous, En stock, Vendus |
| **Photographie** | Prendre une photo ou en choisir une depuis la galerie |
| **Chiffre d'affaires** | Calcul dynamique du CA total base sur les produits vendus |
| **Carrousel** | Banniere animee en haut de la liste principale |
| **Recherche visuelle** | Icones et couleurs distinctives par categorie |
| **Persistance** | Toutes les donnees sont stockees localement (SQLite) |
| **Multi-plateforme** | Android, iOS, Web, Windows, Linux, macOS |

### Categories de produits

- **Boisson** — Jus, infusions, thes
- **Cosmetique** — Huiles, savons, soins
- **Alimentaire** — Poudres, farines, complements
- **Autre** — Autres produits transformes

---

## Apercu des ecrans

| Ecran | Role |
|---|---|
| **Liste des produits** | Accueil : carrousel, chiffre d'affaires, filtres, liste, FAB d'ajout |
| **Detail d'un produit** | Fiche complete : image, infos, valeur totale, actions |
| **Formulaire** | Ajout / modification d'un produit avec validation |
| **A propos** | Credits, sources, informations sur le projet |

---

## Stack technique

| Technologie | Version |
|---|---|
| **Flutter** | 3.41.9 (stable) |
| **Dart** | 3.11.5 |
| **Base de donnees** | SQLite (`sqflite`) |
| **UI** | Material Design 3 (Material You) |
| **Images** | `image_picker` (appareil + galerie) |
| **Formatage** | `intl` (locale `fr_FR`, devise FCFA) |
| **Stockage images** | `path_provider` (systeme de fichiers local) |

---

## Structure du projet

```
lib/
├── main.dart                         # Point d'entree, routes, theme
├── models/
│   └── produit_transforme.dart       # Modele + enum Categorie
├── screens/
│   ├── liste_produits_screen.dart    # Liste principale avec carrousel & filtres
│   ├── detail_produit_screen.dart    # Detail d'un produit
│   ├── formulaire_screen.dart        # Formulaire d'ajout/modification
│   └── about_screen.dart             # Ecran A propos
├── services/
│   └── database_helper.dart          # Service SQLite (singleton)
└── widgets/
    ├── badge_statut.dart             # Badge En stock / Vendu
    └── produit_card.dart             # Carte produit reutilisable
```

---

## Installation et demarrage

### Prerequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.0.0
- Dart (inclus avec Flutter)
- Un IDE (VS Code, Android Studio, IntelliJ)

### Etapes

```bash
# 1. Cloner le depot
git clone <url-du-depot>
cd gie_produits

# 2. Installer les dependances
flutter pub get

# 3. Lancer l'application
flutter run                    # Peripherique connecte
flutter run -d chrome          # Navigateur web
flutter run -d windows         # Bureau Windows
flutter run -d android         # Android
flutter run -d ios             # iOS (macOS requis)
```

### Construire pour la production

```bash
flutter build apk              # Android
flutter build ios              # iOS (macOS requis)
flutter build web              # Web
flutter build windows          # Windows
flutter build linux            # Linux
flutter build macos            # macOS
```

### Tests

```bash
flutter test
```

---

## Schema de la base de donnees

```sql
CREATE TABLE produits (
  id               TEXT    PRIMARY KEY,
  produit          TEXT    NOT NULL,
  categorie        TEXT    NOT NULL,
  quantite_produite INTEGER NOT NULL,
  prix_unitaire    INTEGER NOT NULL,
  date_production  TEXT    NOT NULL,
  vendu            INTEGER NOT NULL DEFAULT 0,
  image_path       TEXT
);
```

---

## Produits de demonstration

| Produit | Categorie | Qte | Prix unitaire |
|---|---|---|---|
| Poudre de Nep-Nep | Alimentaire | 25 | 4 500 FCFA |
| The Wass / Kinkeliba | Boisson | 40 | 3 200 FCFA |
| Feuilles de Nguer | Cosmetique | 20 | 3 900 FCFA |
| Poudre de Baobab | Alimentaire | 35 | 5 000 FCFA |
| Huile de coco bio | Cosmetique | 15 | 6 500 FCFA |

---

## Auteur

**Mamadou Saliou DIALLO** — Sujet n 13
- Promotion DAR26 — Licence 3
- ESMT Dakar (Ecole Superieure Multinationale des Telecommunications)
- Module : Developpement Multiplateforme — 2026

---

## Licence

Ce projet est realise dans un cadre academique. Les donnees produits sont une reproduction a titre educatif de la gamme du GIE **Jolof Teranga**.
