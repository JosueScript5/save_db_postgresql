#!/bin/bash

# Charger les variables d’environnement du fichier .env
set -a
source .env
set +a

# Vérification des variables
if [[ -z "$SUPABASE_URL" || -z "$SUPABASE_API_KEY" ]]; then
  echo "⚠️  Variables d’environnement manquantes. Vérifie ton fichier .env"
  exit 1
fi

# Fonction : Voir les enregistrements d'une table
show_table_data() {
  read -p "📝 Nom de la table à consulter : " table_name
  echo "📥 Récupération des données depuis '$table_name'..."
  response=$(curl -s "$SUPABASE_URL/rest/v1/$table_name?select=*" \
    -H "apikey: $SUPABASE_API_KEY" \
    -H "Authorization: Bearer $SUPABASE_API_KEY" \
    -H "Accept: application/json")
  echo "✅ Données reçues :"
  echo "$response" | jq .
  echo ""
}

# Fonction : Télécharger les données d'une table
download_table_data() {
  read -p "📦 Nom de la base de données : " db_name
  read -p "📝 Nom de la table à télécharger : " table_name
  read -p "✅ Confirmer le téléchargement ? (o/n) : " confirm

  if [[ "$confirm" != "o" && "$confirm" != "O" ]]; then
    echo "❌ Téléchargement annulé."
    return
  fi

  # Créer dossier db/NOM_BDD si non existant
  dir_path="db/$db_name"
  mkdir -p "$dir_path"

  # Télécharger les données
  echo "⬇️ Téléchargement des données de '$table_name'..."
  response=$(curl -s "$SUPABASE_URL/rest/v1/$table_name?select=*" \
    -H "apikey: $SUPABASE_API_KEY" \
    -H "Authorization: Bearer $SUPABASE_API_KEY" \
    -H "Accept: application/json")

  # Vérifier si la réponse contient des erreurs
  if echo "$response" | jq empty 2>/dev/null; then
    file_path="$dir_path/${table_name}.txt"
    echo "$response" | jq '.' > "$file_path"
    echo "✅ Données sauvegardées dans '$file_path'"
  else
    echo "❌ Erreur lors de la récupération des données ou table introuvable."
  fi
}

# Boucle principale
while true; do
  echo "======= MENU ======="
  echo "1. 📂 Voir les enregistrements d'une table"
  echo "2. 💾 Télécharger les enregistrements d'une table (format .txt)"
  echo "3. ❌ Quitter"
  echo "===================="
  read -p "Choix (1-3) : " choix

  case $choix in
    1)
      show_table_data
      ;;
    2)
      download_table_data
      ;;
    3)
      echo "👋 Fin du programme. À bientôt !"
      exit 0
      ;;
    *)
      echo "❌ Option invalide. Réessaie."
      ;;
  esac
done
