# 🔐 Supabase Bash Client

Ce projet est un script Bash permettant de **récupérer, comparer et mettre à jour les données d'une base PostgreSQL hébergée sur Supabase** via l'API REST, tout en sécurisant les identifiants via un fichier `.env`.

---

## 1. ⚙️ Prérequis

- Système : Linux, macOS ou WSL sous Windows
- Outils nécessaires :
  - `bash`
  - `curl`
  - `jq` (pour afficher le JSON formaté)

---

## 2. 🛠️ Installation de `jq`

Ouvre ton terminal et exécute la commande suivante :

```bash
sudo apt update && sudo apt install jq
```

---

## 3. 📦 Cloner ce projet

Clone ce dépôt Git contenant le script :

```bash
git clone https://github.com/JosueScript5/save_db_postgresql.git
cd save_db_postgresql
```

---

## 4. 🔧 Configuration

Crée un fichier `.env` à la racine du projet avec le contenu suivant :

```env
SUPABASE_URL="https://ton-project-id.supabase.co"
SUPABASE_API_KEY="ta-cle-api"
```

Remplace `ton-project-id` et `ta-cle-api` par les valeurs fournies par Supabase.

---

## 5. 🚀 Lancer le script

Rends le script exécutable puis lance-le :

```bash
chmod +x main.sh
./main.sh
```

---

## 📋 Fonctionnalités du script

Une fois lancé, le script propose plusieurs options :

1. 🛠️ Voir les noms des tables modifiées sur Supabase par rapport à la base locale
2. 👁️ Voir les enregistrements d'une table en choisissant parmi les bases locales disponibles
3. 💾 Télécharger plusieurs tables depuis Supabase vers une base locale
4. 🔄 Mettre à jour une base locale existante
5. ❌ Quitter le programme

Chaque option est interactive et guidée. Il vous suffit de suivre les instructions affichées dans le terminal.

---

## 📁 Structure du dossier `db/`

Les bases locales sont enregistrées dans un dossier `db/` organisé ainsi :

```
db/
├── ma_base/
│   ├── users.txt
│   ├── clients.txt
│   └── ...
└── autre_base/
    ├── ...
```

Chaque fichier `.txt` contient les données d'une table Supabase, sauvegardées au format JSON.

---

## 👨‍💻 Auteur

Script écrit par [JosueScript5](https://github.com/JosueScript5)

---

## 📜 Licence

Ce projet est libre d'utilisation et modifiable sous licence MIT.
