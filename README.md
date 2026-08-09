# Orléans Connect

> La plateforme communautaire locale des Orléanais : actualités, annuaire des
> commerces, mobilité et recommandations personnalisées — sur mobile (Android &
> iOS) et web, avec une base de code unique en **Flutter**.

<p>
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.27%2B-02569B">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.6%2B-0175C2">
  <img alt="Plateformes" src="https://img.shields.io/badge/Plateformes-Android%20%7C%20iOS%20%7C%20Web-14294B">
  <img alt="Statut" src="https://img.shields.io/badge/Statut-MVP-E8792B">
</p>

---

## Sommaire

- [Ce que fait l'application](#ce-que-fait-lapplication)
- [Démarrage rapide](#démarrage-rapide)
- [Architecture](#architecture)
- [Structure des dossiers](#structure-des-dossiers)
- [Le moteur de recommandations](#le-moteur-de-recommandations)
- [Brancher un vrai backend](#brancher-un-vrai-backend)
- [Build & déploiement](#build--déploiement)
- [Feuille de route](#feuille-de-route)
- [Budget de lancement](#budget-de-lancement)

---

## Ce que fait l'application

L'application est organisée en **quatre modules** (les quatre onglets), plus un
écran de profil :

| Module | Onglet | Contenu |
| --- | --- | --- |
| **Fil d'actualité** | Actus | Événements, culture, sport, vie municipale, alertes, filtrables par rubrique. |
| **Annuaire** | Annuaire | Commerces et services de proximité, avec recherche plein texte et filtres. |
| **Mobilité** | Mobilité | État des transports TAO (tram/bus) + covoiturage local (proposer/réserver). |
| **Recommandations** | Pour vous | Suggestions personnalisées, notées et **expliquées**, à partir de votre profil. |

> **Important pour le MVP** : toutes les données proviennent d'un jeu local
> mocké (`lib/data/mock_data.dart`). L'application est donc **100 %
> fonctionnelle sans backend** — idéal pour démontrer, filmer les vidéos promo
> et itérer vite. La couche d'accès aux données est déjà isolée pour brancher
> une vraie API sans toucher à l'interface (voir plus bas).

---

## Démarrage rapide

> **Prérequis** : [Flutter SDK 3.27+](https://docs.flutter.dev/get-started/install)
> installé (`flutter doctor` sans erreur bloquante).

Ce dépôt contient le code source (`lib/`), la configuration et les tests. Les
dossiers spécifiques aux plateformes (`android/`, `ios/`, `web/`,
`macos/`…) ne sont **pas** versionnés : ils se régénèrent en une commande.

```bash
# 1. Récupérer le projet
git clone <url-du-dépôt> && cd Orleans-CONNECT

# 2. Générer les dossiers de plateforme SANS écraser lib/ ni pubspec.yaml
flutter create .

# 3. Installer les dépendances
flutter pub get

# 4. Lancer (choisir la cible)
flutter run -d chrome     # Web
flutter run -d <deviceId> # Mobile (voir `flutter devices`)

# 5. Vérifier la qualité
flutter analyze
flutter test
```

> `flutter create .` est **idempotent et non destructif** pour `lib/` : il
> ajoute seulement l'échafaudage des plateformes. Vous pouvez le relancer sans
> risque.

---

## Architecture

L'application suit une organisation **par fonctionnalité** (*feature-first*),
avec une séparation nette entre données, logique et présentation. Le flux
ressemble à une petite architecture en couches — une logique familière si vous
venez du backend (Django/services) :

```
   UI (features/*)                    ← écrans & widgets, aucun accès direct aux données
        │  lit via
        ▼
   Repositories (data/repositories)   ← contrat d'accès aux données (async)
        │  aujourd'hui
        ▼
   MockData (data/mock_data.dart)     ← à remplacer par des appels HTTP vers l'API
```

- **`provider`** injecte les dépôts et le contrôleur de profil dans l'arbre de
  widgets (injection de dépendances). Un seul point de câblage :
  `lib/app/dependencies.dart`.
- **`go_router`** gère la navigation déclarative avec des URLs propres (utile
  sur le web) et une barre d'onglets à état persistant.
- **`ProfileController`** (`ChangeNotifier`) détient les préférences ; l'onglet
  « Pour vous » l'observe et se recalcule automatiquement.

Analogie DevOps/Data : les *repositories* jouent le rôle d'une couche d'accès
type DAO/ORM ; `MockData` est une base « en dur » que l'on remplacera par la
vraie source (API REST, puis éventuellement un service de reco côté Data).

---

## Structure des dossiers

```
lib/
├── main.dart                     # Point d'entrée
├── app/
│   ├── app.dart                  # MaterialApp.router + thème
│   └── dependencies.dart         # Injection (Provider) — point de câblage unique
├── core/
│   ├── router/app_router.dart    # Routes & navigation par onglets
│   ├── theme/                    # Palette de marque + ThemeData
│   └── utils/date_format.dart    # Formatage des dates en français
├── models/                       # Modèles (news, business, ride, reco, profil)
├── data/
│   ├── mock_data.dart            # Jeu de données de démonstration
│   └── repositories/             # Accès données + moteur de recommandations
├── features/                     # Un dossier par module
│   ├── home/                     # Coquille + barre de navigation
│   ├── news/  directory/  mobility/  recommendations/  profile/
└── shared/widgets/               # Widgets réutilisables (marque, états async…)
test/
└── recommendation_engine_test.dart
```

---

## Le moteur de recommandations

`lib/data/repositories/recommendation_engine.dart` implémente une reco
**content-based** volontairement simple et **explicable** : chaque candidat
(commerce, actu, trajet) reçoit un score dans `[0, 1]` combinant des signaux
pondérés, puis on trie et on garde le haut du panier.

Signaux actuels : correspondance de catégorie (poids fort), proximité de
quartier, qualité (note moyenne), fraîcheur/imminence. Chaque suggestion
embarque une phrase « Parce que… » affichée à l'utilisateur.

Cette structure pondérée et testée (`test/recommendation_engine_test.dart`) est
une base idéale pour votre orientation Data/IA : elle se remplace ensuite
proprement par un modèle appris (filtrage collaboratif ou hybride) exposé via
le backend, sans rien changer à l'UI.

---

## Brancher un vrai backend

Le reste de l'application ne dépend que des **interfaces** de dépôts. Pour
passer du mock à une API :

1. Ajouter un client HTTP (ex. `http` ou `dio`) dans `pubspec.yaml`.
2. Créer une implémentation, ex. `ApiNewsRepository`, qui appelle l'API et
   désérialise via les `fromJson` déjà présents sur chaque modèle.
3. La brancher dans `lib/app/dependencies.dart`. **Aucun écran à modifier.**

Un backend **Django REST Framework** (dans votre zone de confort) est un
excellent choix : il expose les endpoints `news / businesses / rides`, gère
l'authentification et pourra héberger le service de recommandations.

---

## Build & déploiement

```bash
# Web (dossier build/web/ à héberger, ex. Hostinger)
flutter build web --release

# Android — App Bundle pour le Play Store
flutter build appbundle --release

# iOS (nécessite macOS + Xcode)
flutter build ipa --release
```

| Cible | Sortie | Destination |
| --- | --- | --- |
| Web | `build/web/` | Hébergement statique (Hostinger, Netlify…) |
| Android | `build/app/outputs/bundle/release/app-release.aab` | Google Play Console |
| iOS | `build/ios/ipa/*.ipa` | App Store Connect (via Xcode/Transporter) |

> Signature : ne **jamais** committer les clés (`*.jks`, `*.p12`,
> `key.properties`, certificats). Elles sont déjà ignorées dans `.gitignore`.

---

## Feuille de route

**MVP (cette base)** — ✅ 4 modules fonctionnels sur données mockées, navigation,
thème de marque, moteur de reco expliqué, tests unitaires.

**Prochaines étapes suggérées :**
- [ ] Backend Django REST + implémentations `Api*Repository`.
- [ ] Persistance locale du profil (`shared_preferences`).
- [ ] Authentification (compte Orléanais) et modération de contenu.
- [ ] Carte interactive (annuaire & covoiturage) + itinéraires.
- [ ] Notifications push (alertes locales, réponses covoiturage).
- [ ] Intégration des données ouvertes (open data ville / TAO temps réel).
- [ ] Logo officiel dans `assets/images` (remplacer le `BrandMark` textuel).

---

## Budget de lancement

| Poste | Coût |
| --- | --- |
| Google Play (compte développeur) | 25 $ (une fois) |
| Apple Developer Program | 99 $ / an |
| Hébergement web (type Hostinger) | ~50–75 $ / an |
| **Total estimé au lancement** | **≈ 175–200 $** |

---

<p align="center"><i>Orléans Connect — rassembler les Orléanais, en ligne comme dans la ville.</i></p>
