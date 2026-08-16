# Architecture d'Orléans Connect — le guide pour tout comprendre

> Ce document explique **comment le projet est construit** et **pourquoi**, en
> partant de zéro. Il est écrit pour quelqu'un qui connaît le développement
> côté serveur (Python/Django), Linux, Docker et Git, mais qui découvre
> **Flutter/Dart**. Chaque concept nouveau est relié à quelque chose que tu
> connais déjà.

## Sommaire
1. [Le modèle mental Flutter (pour un back/DevOps)](#1-le-modèle-mental-flutter)
2. [Le vocabulaire Dart minimal](#2-le-vocabulaire-dart-minimal)
3. [L'architecture en couches](#3-larchitecture-en-couches)
4. [Le flux d'exécution, pas à pas](#4-le-flux-dexécution-pas-à-pas)
5. [Les 5 dossiers de `lib/`](#5-les-5-dossiers-de-lib)
6. [Le moteur de recommandations en détail](#6-le-moteur-de-recommandations)
7. [Comment on branchera un vrai backend](#7-comment-on-branchera-un-vrai-backend)
8. [Glossaire express](#8-glossaire-express)

---

## 1. Le modèle mental Flutter

En développement web classique (Django), tu génères du **HTML** que le
navigateur affiche. En Flutter, il n'y a pas de HTML : **tout est un
« widget »**, un objet Dart qui décrit un morceau d'interface. Un écran est un
arbre de widgets (un bouton dans une colonne dans une page…), un peu comme un
DOM, mais 100 % en code Dart.

Analogie utile :

| Côté serveur (Django) | Côté Flutter |
| --- | --- |
| Un template `.html` | Un `Widget` (classe Dart) |
| La vue qui assemble le contexte | Le `build()` d'un widget |
| Le routeur `urls.py` | `go_router` (`lib/core/router/`) |
| Le modèle ORM | Les classes de `lib/models/` |
| La couche service / DAO | Les `repositories/` |
| `settings.py` / injection | `lib/app/dependencies.dart` |
| Les tests `pytest` | `test/` avec `flutter_test` |

**Point clé :** en Flutter, l'interface est une **fonction de l'état**. Tu ne
manipules pas l'écran « à la main » (comme en jQuery). Tu changes une donnée,
et le framework **reconstruit** (`rebuild`) la partie d'écran concernée. C'est
le même esprit que du rendu déclaratif (React), pas de l'impératif.

---

## 2. Le vocabulaire Dart minimal

Juste ce qu'il faut pour lire le code du projet :

- **`class` / `final`** : comme partout. `final` = variable assignée une fois
  (proche d'une constante d'instance).
- **`StatelessWidget`** : un widget **sans état interne**. Il se dessine à
  partir de ce qu'on lui passe. (Ex. une carte d'actualité qui affiche un
  article.)
- **`StatefulWidget`** : un widget **avec état mutable** (ex. le filtre
  sélectionné dans une liste). Quand on appelle `setState(...)`, Flutter
  redessine ce widget.
- **`Future<T>`** : une valeur **asynchrone** — l'équivalent d'une coroutine
  `async` en Python. `await` attend le résultat. On l'utilise pour tout ce qui
  « prend du temps » (réseau, base de données).
- **`enum`** : une énumération fermée (ex. les catégories de commerce). On s'en
  sert beaucoup pour éviter les « chaînes magiques ».
- **`?` (nullable)** : `String?` = « une chaîne **ou** `null` ». Dart est
  *null-safe* : le compilateur t'oblige à gérer le cas `null`. C'est une
  sécurité, pas une contrainte gratuite.

---

## 3. L'architecture en couches

Le projet suit une organisation **feature-first** (un dossier par
fonctionnalité) avec une **séparation stricte** entre l'affichage et les
données. Vu de haut :

```
┌─────────────────────────────────────────────┐
│  PRÉSENTATION  (lib/features/*)              │
│  Écrans + widgets. Ne connaissent PAS        │
│  l'origine des données. Ils demandent.       │
└───────────────────────┬─────────────────────┘
                        │  appelle des méthodes async
                        ▼
┌─────────────────────────────────────────────┐
│  ACCÈS DONNÉES  (lib/data/repositories/*)    │
│  Un "contrat" : fetchNews(), fetchAll()...   │
│  L'UI ne dépend QUE de ça.                    │
└───────────────────────┬─────────────────────┘
                        │  aujourd'hui : lit en mémoire
                        ▼
┌─────────────────────────────────────────────┐
│  SOURCE  (lib/data/mock_data.dart)           │
│  Données en dur. DEMAIN : appels HTTP vers   │
│  une API Django REST, sans toucher au reste. │
└─────────────────────────────────────────────┘
```

**Pourquoi cette séparation ?** C'est le principe d'**inversion de
dépendance**, exactement comme quand tu mets une interface entre ton service
métier et ta base. Bénéfice concret ici : passer des données mockées à une
vraie API ne touchera **aucun écran** — seulement les classes `repositories/`
et une ligne de câblage.

---

## 4. Le flux d'exécution, pas à pas

Suis ce chemin, fichier par fichier, pour voir « qui appelle quoi » :

1. **`lib/main.dart`** — `runApp(const OrleansConnectApp())`. Le démarrage,
   comme un `if __name__ == "__main__"`.
2. **`lib/app/app.dart`** — construit `MaterialApp.router` : applique le
   **thème** et branche le **routeur**. C'est la racine de l'arbre de widgets.
3. **`lib/app/dependencies.dart`** — enveloppe l'app dans des `Provider`. C'est
   **le point de câblage unique** : on y crée les repositories et le
   contrôleur de profil, rendus disponibles à tout l'arbre. (Comme la config
   d'injection d'un backend.)
4. **`lib/core/router/app_router.dart`** — déclare les routes et la **barre
   d'onglets** (les 4 modules). Chaque onglet garde son état.
5. **Un écran, ex. `lib/features/news/news_screen.dart`** — au `build()`, il
   récupère son repository via `context.read<NewsRepository>()` puis affiche le
   résultat du `Future` grâce au widget maison `AsyncView` (qui gère
   chargement / erreur / vide de façon homogène).
6. **`lib/data/repositories/news_repository.dart`** — renvoie les données (ici,
   depuis `MockData`). C'est ici, et **seulement ici**, qu'on branchera l'API.

> 💡 Retiens ce sens de lecture : **entrée → app → câblage → routeur → écran →
> repository → données**. Tout le reste n'est que du détail d'affichage.

---

## 5. Les 5 dossiers de `lib/`

```
lib/
├── main.dart          # démarrage
├── app/               # assemblage global (app racine + injection)
├── core/              # briques transverses : thème, routeur, utilitaires
├── models/            # structures de données pures (aucune logique d'UI)
├── data/              # mock_data + repositories (accès données) + moteur reco
├── features/          # 1 dossier par module (news, directory, mobility,
│                      #   recommendations, profile, home)
└── shared/            # widgets réutilisés partout (marque, états async)
```

Règle mentale simple :
- **`models/`** = *quoi* (les données) — l'équivalent de tes modèles ORM, mais
  sans base derrière.
- **`data/`** = *d'où* (la provenance et l'accès).
- **`features/`** = *comment on l'affiche*.
- **`core/` + `shared/`** = *les fondations communes*.

---

## 6. Le moteur de recommandations

Fichier : `lib/data/repositories/recommendation_engine.dart`. C'est le morceau
le plus intéressant pour ton orientation **Data/IA**, et il est volontairement
**simple et explicable**.

**Principe** (reco *content-based*, « basée sur le contenu ») : pour chaque
candidat (un commerce, une actu, un trajet), on calcule un **score** entre 0 et
1 en additionnant des **signaux pondérés** :

```
score = 0.55 · (catégorie correspond à mes centres d'intérêt ?)
      + 0.20 · (c'est dans mon quartier ?)
      + 0.15 · (note moyenne / 5)
      + 0.20 · (fraîcheur : récent ? départ imminent ?)
```

On trie ensuite par score décroissant et on garde le haut du panier. Surtout,
chaque suggestion embarque une **explication lisible** (« Parce que rubrique
suivie, publié récemment. ») — la transparence est un choix de conception.

**Pourquoi c'est une bonne base Data :** cette structure « signaux pondérés +
score » est exactement le point de départ d'un système plus avancé. Le jour où
tu veux un modèle appris (filtrage collaboratif, hybride), tu remplaces le
calcul du score par les prédictions d'un modèle exposé côté backend — l'UI, qui
ne connaît que « une liste de `Recommendation` triée », ne change pas.

**Comment c'est verrouillé :** `test/recommendation_engine_test.dart` vérifie le
tri, les bornes `[0,1]`, l'effet d'un centre d'intérêt ajouté, et la présence
d'une explication. Lance-les avec `flutter test`.

---

## 7. Comment on branchera un vrai backend

C'est la suite logique, et c'est **ta zone de confort** (Django/Python). Le plan :

1. Ajouter un client HTTP dans `pubspec.yaml` (`http` ou `dio`).
2. Créer une implémentation par ressource, ex. `ApiNewsRepository`, qui appelle
   l'API et transforme le JSON via les méthodes `fromJson` **déjà présentes**
   sur chaque modèle.
3. La brancher dans `lib/app/dependencies.dart` — **une ligne** :
   `Provider<NewsRepository>(create: (_) => ApiNewsRepository(...))`.
4. **Aucun écran à modifier.** C'est tout l'intérêt de la couche repository.

Côté serveur, un **Django REST Framework** expose `/news`, `/businesses`,
`/rides`, gère l'authentification et pourra héberger le service de reco. Tu
retrouves ton terrain habituel (Python, Docker, Linux).

---

## 8. Glossaire express

| Terme | En une phrase |
| --- | --- |
| **Widget** | Un objet Dart qui décrit une partie de l'interface. |
| **build()** | La méthode qui construit l'arbre de widgets d'un écran. |
| **StatelessWidget** | Widget sans état interne (juste de l'affichage). |
| **StatefulWidget** | Widget avec état mutable ; `setState()` le redessine. |
| **Provider** | Injection de dépendances : rend un objet dispo dans l'arbre. |
| **ChangeNotifier** | Un objet qui prévient l'UI quand ses données changent. |
| **go_router** | Le routeur : associe des URLs à des écrans. |
| **Future** | Une valeur asynchrone (comme `async` en Python). |
| **Repository** | La classe qui fournit les données, quelle que soit la source. |
| **pub / pubspec** | Le gestionnaire de paquets Dart (comme `pip`/`requirements`). |

---

> Une question sur un fichier précis ? Ouvre-le en suivant l'ordre de la
> section 4 — et n'hésite pas à demander une explication ligne à ligne.
