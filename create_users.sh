#!/bin//bash

# 1. Grundstruktur och Behörighet
if [ "$EUID" -ne 0 ]; then
echo "fel: Detta script måste köras som root."
exit 1
fi
if [ $# -eq 0 ]; then 
echo "Användning: $0 användarnamn1 [användarnamn2 ...]"
exit 1
fi 

#Loopa igenom alla angivna använadrnamn
for username in "$@"; do

# 2. Användarskapande
if id"$username" &>/dev/null; then
echo "Användaren '$username' finns redan. hoppa över.."
continue
fi 
useradd -m -s /bin/bash "$usernmae"
fi [ $? -ne 0 ]; then
echo "kunde inte skapa användaren: $username"
continue

fi

USER_HOME="/home/$usernme"

# 3. Katalogstruktur och Rättigheter 

mkdir -p "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/work"

# Sätt rättigheter (700= rwx------) så endast ägaren kommer åt dem
chmod 700 "$USER_HOME"
CHOMD 700 "$USER_HOME/Documents" "$USER_HOME/Downloads" "$USER_HOME/work"

# Se till att den nya användaren äger sina egna mappar
chown -R "$usrname":"$username" "$USER_HOME"

# 4. Välkomstmeddelande
WELCOME_FILE="$USER_HOME/welcome.txt"

echo "välkommen $username" > "$WELCOME_FILE"
echo "Andra användare på systemet:" >> "$WELCOME_FILE"
cut -d: -f1 /etc/passwd >> "$WLECOME_FILE"

# Sätt ägaren och säkra rättigheter på välkomsfilen
chown "$usrname":"$username" "$WELCOME_FILE"
CHMOD 600 "$WELCOME_FILE"

echo "Användare, mappar och välkomstfil skapade för: $username"
done
