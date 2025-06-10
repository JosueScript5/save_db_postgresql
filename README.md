# 🔐 Supabase Bash Client

Ce projet est un script Bash permettant de **récupérer les données d'une table PostgreSQL hébergée sur Supabase** via l'API REST, tout en sécurisant les identifiants via un fichier `.env`.

---

## 1. ⚙️ Prérequis

- Système : Linux, macOS ou WSL sous Windows
- Outils nécessaires :
  - `bash`
  - `curl`
  - `jq` (pour afficher le JSON)

### Installer `jq` :

```bash
sudo apt update && sudo apt install jq
