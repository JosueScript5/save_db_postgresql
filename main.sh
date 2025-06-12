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

check_modified_tables() {
  echo "📚 Bases locales disponibles :"
  ls db/ 2>/dev/null || { echo "❌ Aucun dossier de base de données trouvé."; return; }

  read -p "📦 Nom de la base de données locale à vérifier : " db_name
  local_dir="db/$db_name"

  if [[ ! -d "$local_dir" ]]; then
    echo "❌ Dossier '$local_dir' introuvable."
    return
  fi

  echo "🔍 Vérification des tables modifiées dans '$db_name'..."

  modified=false

  for file in "$local_dir"/*.txt; do
    table_name=$(basename "$file" .txt)

    response=$(curl -s "$SUPABASE_URL/rest/v1/$table_name?select=*" \
      -H "apikey: $SUPABASE_API_KEY" \
      -H "Authorization: Bearer $SUPABASE_API_KEY" \
      -H "Accept: application/json")

    remote_hash=$(echo "$response" | jq -S . | sha256sum | awk '{print $1}')
    local_hash=$(jq -S . "$file" | sha256sum | awk '{print $1}')

    if [[ "$remote_hash" != "$local_hash" ]]; then
      echo "🛠️  Table modifiée : $table_name"
      modified=true
    fi
  done

  if [[ $modified == false ]]; then
    echo "✅ Aucune modification détectée."
  fi
}

# Fonction : Voir les éléments d'une table
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

# Fonction : Télécharger plusieurs tables
download_multiple_tables() {
  read -p "📦 Nom de la base de données : " db_name
  read -p "📝 Noms des tables à télécharger (séparées par des espaces) : " -a tables

  dir_path="db/$db_name"
  mkdir -p "$dir_path"

  for table_name in "${tables[@]}"; do
    echo "⬇️ Téléchargement de '$table_name'..."
    response=$(curl -s "$SUPABASE_URL/rest/v1/$table_name?select=*" \
      -H "apikey: $SUPABASE_API_KEY" \
      -H "Authorization: Bearer $SUPABASE_API_KEY" \
      -H "Accept: application/json")

    if echo "$response" | jq empty 2>/dev/null; then
      file_path="$dir_path/${table_name}.txt"
      echo "$response" | jq '.' > "$file_path"
      echo "✅ '$table_name' sauvegardée dans '$file_path'"
    else
      echo "❌ Erreur : table '$table_name' introuvable."
    fi
  done
}

# Fonction : Mettre à jour une base existante
update_database() {
  echo "📚 Bases locales disponibles :"
  ls db/ 2>/dev/null || { echo "❌ Aucun dossier de base de données trouvé."; return; }
  
  read -p "📝 Nom de la base à mettre à jour : " db_name
  dir_path="db/$db_name"

  if [[ ! -d "$dir_path" ]]; then
    echo "❌ Base '$db_name' inexistante en local."
    return
  fi

  for file in "$dir_path"/*.txt; do
    table_name=$(basename "$file" .txt)
    echo "🔄 Mise à jour de '$table_name'..."
    response=$(curl -s "$SUPABASE_URL/rest/v1/$table_name?select=*" \
      -H "apikey: $SUPABASE_API_KEY" \
      -H "Authorization: Bearer $SUPABASE_API_KEY" \
      -H "Accept: application/json")

    if echo "$response" | jq empty 2>/dev/null; then
      echo "$response" | jq '.' > "$file"
      echo "✅ Table '$table_name' mise à jour."
    else
      echo "❌ Table '$table_name' introuvable à distance."
    fi
  done
}

# Boucle principale
while true; do
  echo "======= MENU ======="
  echo "1. 🛠️  Voir les noms des tables modifiées"
  echo "2. 👁️  Voir les enregistrements d'une table"
  echo "3. 💾 Télécharger plusieurs tables"
  echo "4. 🔄 Mettre à jour une base de données locale"
  echo "5. ❌ Quitter"
  echo "===================="
  read -p "Choix (1-5) : " choix

  case $choix in
    1)
      check_modified_tables
      ;;
    2)
      show_table_data
      ;;
    3)
      download_multiple_tables
      ;;
    4)
      update_database
      ;;
    5)
      echo "👋 Fin du programme. À bientôt !"
      exit 0
      ;;
    *)
      echo "❌ Option invalide. Réessaie."
      ;;
  esac
done
