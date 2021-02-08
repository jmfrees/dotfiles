# User services
systemctl --user enable --now pulseaudio
systemctl --user enable --now dunst

# System services
systemctl enable --now tlp
