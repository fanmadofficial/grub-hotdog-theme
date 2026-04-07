#!/bin/bash
# 🌭 HOT DOG GRUB THEME - Instalator
# Uruchom z katalogu gdzie jest hotdog-grub-theme/
# czyli np. z ~/Downloads/

set -e

# Katalog w którym leży ten skrypt
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🌭 Instalacja HOT DOG GRUB theme..."

# Usuń stary plik/folder themes jeśli istnieje
if [ -e /boot/grub/themes ]; then
    echo "→ Usuwam stary /boot/grub/themes..."
    sudo rm -rf /boot/grub/themes
fi

# Stwórz folder i skopiuj theme
echo "→ Kopiuję theme..."
sudo mkdir -p /boot/grub/themes/hotdog
sudo cp -r "$SCRIPT_DIR"/* /boot/grub/themes/hotdog/

# Wygeneruj czcionkę
echo "→ Generuję czcionkę..."
sudo grub-mkfont -s 18 -o /boot/grub/themes/hotdog/font18.pf2 \
    /usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf

# Popraw nazwy czcionek w theme.txt
echo "→ Aktualizuję theme.txt..."
sudo sed -i 's/Unknown Regular/DejaVu Sans Mono Regular/g' \
    /boot/grub/themes/hotdog/theme.txt

# Dodaj/zamień GRUB_THEME w /etc/default/grub
echo "→ Ustawiam GRUB_THEME..."
if grep -q "^GRUB_THEME=" /etc/default/grub; then
    sudo sed -i 's|^GRUB_THEME=.*|GRUB_THEME="/boot/grub/themes/hotdog/theme.txt"|' \
        /etc/default/grub
else
    echo 'GRUB_THEME="/boot/grub/themes/hotdog/theme.txt"' | sudo tee -a /etc/default/grub
fi

# Zaktualizuj GRUB
echo "→ Uruchamiam update-grub..."
sudo update-grub

echo ""
echo "✅ Gotowe! Uruchom ponownie żeby zobaczyć musztardę. 🌭"
