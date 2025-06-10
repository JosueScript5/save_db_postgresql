#!/bin/bash

# Charger les variables d’environnement du fichier .env
set -a
source .env
set +a

# Vérification
if [[ -z "$SUPABASE_URL" || -z "$SUPABASE_API_KEY" || -z "$SUPABASE_TABLE" ]]; then
  echo "⚠️  Variables d’environnement manquantes. Vérifie ton fichier .env"
  exit 1
fi

# URL de l’API REST
API_ENDPOINT="$SUPABASE_URL/rest/v1/$SUPABASE_TABLE"

# Requête GET pour récupérer les données
echo "📥 Récupération des données depuis la table '$SUPABASE_TABLE'..."
response=$(curl -s "$API_ENDPOINT" \
  -H "apikey: $SUPABASE_API_KEY" \
  -H "Authorization: Bearer $SUPABASE_API_KEY" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json")

# Affichage
echo "✅ Données reçues :"
echo "$response" | jq .
