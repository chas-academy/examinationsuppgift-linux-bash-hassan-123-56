#!/bin/bash

# --- Grundstruktur och Behörighet ---
if [ "$EUID" -ne 0 ]; then
    echo "fel: Detta script måste köras som root."
    exit 1
fi

if [ $# -eq 0 ]; then 
    echo "Användning: $0 användarnamn1 [användarnamn2 ...]"
    exit 1
fi 

# Loopa igenom alla angivna användarnamn
for username in "$@"; do

    # --- Användarskapande ---
    if id "$username" &>/dev/null; then
        echo "Användaren '$username' finns redan. hoppa över.."
        continue
    fi 

    useradd -m -s /bin/bash "$username"
    
    if [ $? -ne 0 ]; then
        echo "kunde inte skapa användaren: $username"
        continue
    fi

    USER_HOME="/home/$username"

    # --- Katalogstruktur och Rättigheter ---
    mkdir -p "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"
    
    # Sätt rättigheter (700= rwx------) så endast ägaren kommer åt dem
    chmod 700 "$USER_HOME"
    chmod 700 "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/Work"
    
    # Se till att den nya användaren äger sina egna mappar
    chown -R "$username":"$username" "$USER_HOME"

    # --- Välkomstmeddelande ---
    WELCOME_FILE="$USER_HOME/welcome.txt"

    echo "Välkommen $username" > "$WELCOME_FILE"
    echo "Andra användare på systemet:" >> "$WELCOME_FILE"
    cut -d: -f1 /etc/passwd >> "$WELCOME_FILE"
    
    # Sätt ägaren och säkra rättigheter på välkomstfilen
    chown "$username":"$username" "$WELCOME_FILE"
    chmod 600 "$WELCOME_FILE"

    echo "Användare, mappar och välkomstfil skapade för: $username"
done
